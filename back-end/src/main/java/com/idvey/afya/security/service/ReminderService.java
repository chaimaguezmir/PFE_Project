package com.idvey.afya.security.service;

import com.idvey.afya.models.*;
import com.idvey.afya.payload.request.CreateReminderRequest;
import com.idvey.afya.payload.request.ReminderStartSuggestionRequest;
import com.idvey.afya.payload.response.*;
import com.idvey.afya.repository.ReminderRepository;
import com.idvey.afya.repository.TreatmentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReminderService {

	private final ReminderRepository reminderRepository;

	private final TreatmentRepository treatmentRepository;

	@Transactional
	public CreateReminderBulkResponse createRemindersForTreatment(UUID userId, CreateReminderRequest request) {
		log.info("Creating reminders for treatment: {} by user: {}", request.getTreatmentId(), userId);

		// Get and validate treatment
		Treatment treatment = treatmentRepository.findById(request.getTreatmentId())
			.orElseThrow(() -> new NoSuchElementException("Treatment not found"));

		// Verify ownership
		if (!treatment.getPrescription().getUser().getId().equals(userId)) {
			throw new IllegalArgumentException("Treatment does not belong to user");
		}

		// Calculate reminder schedule based on frequency and duration
		List<Reminder> reminders = generateReminders(treatment, request);

		// Save all reminders
		List<Reminder> savedReminders = reminderRepository.saveAll(reminders);
		log.info("Created {} reminders for treatment: {}", savedReminders.size(), request.getTreatmentId());

		// Build response
		return buildBulkResponse(treatment, savedReminders, request);
	}

	private List<Reminder> generateReminders(Treatment treatment, CreateReminderRequest request) {
		List<Reminder> reminders = new ArrayList<>();

		String frequency = treatment.getFrequency().toLowerCase();
		int durationDays = treatment.getDurationDays();

		// Calculate which days to create reminders for
		List<Integer> reminderDays = calculateReminderDays(frequency, durationDays);

		// Get current date and time
		LocalDateTime now = LocalDateTime.now();

		// Handle START_NEXT_CYCLE with proper time slot logic
		LocalDate baseDate;
		List<CreateReminderRequest.ReminderTimeSlot> firstDaySlots;

		if (request.getStartPreference() == CreateReminderRequest.StartPreference.START_NEXT_CYCLE) {
			// Find the next available time slot
			LocalTime currentTime = now.toLocalTime();
			LocalDate today = now.toLocalDate();

			// Filter time slots to find next available ones for today
			List<CreateReminderRequest.ReminderTimeSlot> todaySlots = request.getReminderTimes()
				.stream()
				.filter(slot -> slot.getTime().isAfter(currentTime))
				.sorted((s1, s2) -> s1.getTime().compareTo(s2.getTime()))
				.collect(Collectors.toList());

			if (!todaySlots.isEmpty()) {
				// Start today with remaining slots
				baseDate = today;
				firstDaySlots = todaySlots;
				log.info("START_NEXT_CYCLE: Starting today with {} remaining slots", todaySlots.size());
			}
			else {
				// All slots have passed today, start tomorrow with all slots
				baseDate = today.plusDays(1);
				firstDaySlots = request.getReminderTimes();
				log.info("START_NEXT_CYCLE: All slots passed today, starting tomorrow");
			}
		}
		else {
			baseDate = calculateStartDateSimple(now, request.getStartPreference());
			firstDaySlots = request.getReminderTimes();
		}

		// For each reminder day
		for (Integer dayOffset : reminderDays) {
			LocalDate reminderDate = baseDate.plusDays(dayOffset);

			// Use filtered slots for first day if START_NEXT_CYCLE, all slots for other
			// days
			List<CreateReminderRequest.ReminderTimeSlot> slotsToUse = (dayOffset == 0
					&& request.getStartPreference() == CreateReminderRequest.StartPreference.START_NEXT_CYCLE)
							? firstDaySlots : request.getReminderTimes();

			for (CreateReminderRequest.ReminderTimeSlot timeSlot : slotsToUse) {
				LocalDateTime reminderDateTime = reminderDate.atTime(timeSlot.getTime());

				// Additional check for START_NOW
				if (request.getStartPreference() == CreateReminderRequest.StartPreference.START_NOW && dayOffset == 0
						&& reminderDateTime.isBefore(now)) {
					// Skip this reminder as it's in the past
					continue;
				}

				Reminder reminder = Reminder.builder()
					.treatment(treatment)
					.reminderDateTime(reminderDateTime)
					.timeSlot(timeSlot.getTimeSlot())
					.status(ReminderStatus.SCHEDULED)
					.message(buildReminderMessage(treatment, timeSlot, request.getCustomMessage()))
					.build();

				reminders.add(reminder);
			}
		}

		// Sort reminders by datetime
		reminders.sort((r1, r2) -> r1.getReminderDateTime().compareTo(r2.getReminderDateTime()));

		return reminders;
	}

	private LocalDate calculateStartDateSimple(LocalDateTime now,
			CreateReminderRequest.StartPreference startPreference) {
		return switch (startPreference) {
			case START_TOMORROW -> now.toLocalDate().plusDays(1);
			case START_NEXT_CYCLE -> now.toLocalDate(); // Will be handled specially in
														// generateReminders
			default -> now.toLocalDate();
		};
	}

	@Transactional(readOnly = true)
	public ReminderStartSuggestion getReminderStartSuggestions(ReminderStartSuggestionRequest request) {
		LocalDateTime now = LocalDateTime.now();
		LocalTime currentTime = now.toLocalTime();
		String currentPeriod = getCurrentPeriod(currentTime);

		List<ReminderStartSuggestion.StartOption> options = generateStartOptions(now, request.getReminderTimes());
		ReminderStartSuggestion.StartOption recommended = findRecommendedOption(options, currentTime,
				request.getReminderTimes());

		return new ReminderStartSuggestion(currentTime, currentPeriod, options, recommended);
	}

	private String getCurrentPeriod(LocalTime currentTime) {
		int hour = currentTime.getHour();
		if (hour >= 5 && hour < 12)
			return "morning";
		if (hour >= 12 && hour < 17)
			return "noon";
		if (hour >= 17 && hour < 21)
			return "evening";
		return "night";
	}

	private List<ReminderStartSuggestion.StartOption> generateStartOptions(LocalDateTime now,
			List<CreateReminderRequest.ReminderTimeSlot> timeSlots) {
		List<ReminderStartSuggestion.StartOption> options = new ArrayList<>();
		LocalTime currentTime = now.toLocalTime();

		// Option 1: START_NOW
		LocalDateTime nextAvailableTime = findNextAvailableTime(now, timeSlots);
		options.add(new ReminderStartSuggestion.StartOption(CreateReminderRequest.StartPreference.START_NOW,
				"Start from today", nextAvailableTime,
				"Begin with the next scheduled time today, or tomorrow if all times have passed", false));

		// Option 2: START_NEXT_CYCLE (improved description)
		LocalDateTime nextCycleTime = findNextCycleTime(now, timeSlots);
		String nextSlotDescription = getNextSlotDescription(currentTime, timeSlots);
		options.add(new ReminderStartSuggestion.StartOption(CreateReminderRequest.StartPreference.START_NEXT_CYCLE,
				"Start from next " + nextSlotDescription, nextCycleTime,
				"Begin with the next upcoming time slot: " + nextSlotDescription, true // This
																						// is
																						// usually
																						// the
																						// recommended
																						// option
		));

		// Option 3: START_TOMORROW
		LocalDateTime tomorrowFirstTime = now.toLocalDate().plusDays(1).atTime(timeSlots.get(0).getTime());
		options.add(new ReminderStartSuggestion.StartOption(CreateReminderRequest.StartPreference.START_TOMORROW,
				"Start tomorrow", tomorrowFirstTime, "Begin fresh tomorrow with your first reminder time", false));

		return options;
	}

	private String getNextSlotDescription(LocalTime currentTime,
			List<CreateReminderRequest.ReminderTimeSlot> timeSlots) {
		// Find next time slot
		for (CreateReminderRequest.ReminderTimeSlot slot : timeSlots) {
			if (slot.getTime().isAfter(currentTime)) {
				return getTimeSlotName(slot.getTimeSlot()) + " (" + slot.getTime() + ")";
			}
		}

		// All slots have passed, next is tomorrow's first slot
		CreateReminderRequest.ReminderTimeSlot firstSlot = timeSlots.get(0);
		return "tomorrow's " + getTimeSlotName(firstSlot.getTimeSlot()) + " (" + firstSlot.getTime() + ")";
	}

	private LocalDateTime findNextAvailableTime(LocalDateTime now,
			List<CreateReminderRequest.ReminderTimeSlot> timeSlots) {
		LocalDate today = now.toLocalDate();

		// Find next time today
		for (CreateReminderRequest.ReminderTimeSlot slot : timeSlots) {
			LocalDateTime slotTime = today.atTime(slot.getTime());
			if (slotTime.isAfter(now)) {
				return slotTime;
			}
		}

		// All times have passed today, return first time tomorrow
		return today.plusDays(1).atTime(timeSlots.get(0).getTime());
	}

	private LocalDateTime findNextCycleTime(LocalDateTime now, List<CreateReminderRequest.ReminderTimeSlot> timeSlots) {
		LocalTime currentTime = now.toLocalTime();
		LocalDate today = now.toLocalDate();

		// Find next time slot today
		for (CreateReminderRequest.ReminderTimeSlot slot : timeSlots) {
			if (slot.getTime().isAfter(currentTime)) {
				return today.atTime(slot.getTime());
			}
		}

		// All slots have passed today, return first slot tomorrow
		return today.plusDays(1).atTime(timeSlots.get(0).getTime());
	}

	private ReminderStartSuggestion.StartOption findRecommendedOption(List<ReminderStartSuggestion.StartOption> options,
			LocalTime currentTime, List<CreateReminderRequest.ReminderTimeSlot> timeSlots) {
		// Mark the START_NEXT_CYCLE as recommended by default
		return options.stream()
			.filter(ReminderStartSuggestion.StartOption::isRecommended)
			.findFirst()
			.orElse(options.get(0));
	}

	private String getTimeSlotName(CreateReminderRequest.TimeSlot timeSlot) {
		return switch (timeSlot) {
			case MORNING -> "morning";
			case NOON -> "noon";
			case EVENING -> "evening";
			case NIGHT -> "night";
		};
	}

	private List<Integer> calculateReminderDays(String frequency, int durationDays) {
		List<Integer> days = new ArrayList<>();

		switch (frequency) {
			case "daily":
				// Every day for duration
				for (int i = 0; i < durationDays; i++) {
					days.add(i);
				}
				break;

			case "every other day":
			case "day other day":
				// Every other day (0, 2, 4, 6...)
				for (int i = 0; i < durationDays; i += 2) {
					days.add(i);
				}
				break;

			case "weekly":
				// Once per week
				for (int i = 0; i < durationDays; i += 7) {
					days.add(i);
				}
				break;

			case "twice weekly":
				// Twice per week (e.g., day 0, 3, 7, 10...)
				for (int i = 0; i < durationDays; i += 7) {
					days.add(i);
					if (i + 3 < durationDays) {
						days.add(i + 3);
					}
				}
				break;

			default:
				// Default to daily if frequency not recognized
				log.warn("Unknown frequency '{}', defaulting to daily", frequency);
				for (int i = 0; i < durationDays; i++) {
					days.add(i);
				}
		}

		return days;
	}

	private String buildReminderMessage(Treatment treatment, CreateReminderRequest.ReminderTimeSlot timeSlot,
			String customMessage) {
		if (customMessage != null && !customMessage.trim().isEmpty()) {
			return customMessage;
		}

		String timeSlotName = getTimeSlotDisplayName(timeSlot.getTimeSlot());
		return String.format("Time to take your %s - %s (%s)", treatment.getMyMedicine().getName(),
				treatment.getDosage(), timeSlotName);
	}

	private String getTimeSlotDisplayName(CreateReminderRequest.TimeSlot timeSlot) {
		return switch (timeSlot) {
			case MORNING -> "Morning";
			case NOON -> "Noon";
			case EVENING -> "Evening";
			case NIGHT -> "Night";
		};
	}

	private CreateReminderBulkResponse buildBulkResponse(Treatment treatment, List<Reminder> savedReminders,
			CreateReminderRequest request) {
		// Convert to response DTOs
		List<ReminderResponse> reminderResponses = savedReminders.stream().map(this::toResponse).toList();

		// Build summary
		List<ReminderCreationSummary.TimeSlotSummary> timeSlotSummaries = request.getReminderTimes()
			.stream()
			.map(timeSlot -> {
				long count = savedReminders.stream().filter(r -> r.getTimeSlot() == timeSlot.getTimeSlot()).count();
				return new ReminderCreationSummary.TimeSlotSummary(timeSlot.getTimeSlot(), timeSlot.getTime(),
						(int) count);
			})
			.toList();

		ReminderCreationSummary summary = new ReminderCreationSummary(treatment.getDurationDays(),
				treatment.getFrequency(), timeSlotSummaries);

		String treatmentInfo = String.format("%s - %s %s for %d days", treatment.getMyMedicine().getName(),
				treatment.getDosage(), treatment.getFrequency(), treatment.getDurationDays());

		return new CreateReminderBulkResponse(treatment.getId(), treatmentInfo, savedReminders.size(),
				reminderResponses, summary);
	}

	@Transactional(readOnly = true)
	public List<ReminderResponse> getRemindersByTreatment(UUID userId, UUID treatmentId) {
		// Verify treatment belongs to user
		Treatment treatment = treatmentRepository.findById(treatmentId)
			.orElseThrow(() -> new NoSuchElementException("Treatment not found"));

		if (!treatment.getPrescription().getUser().getId().equals(userId)) {
			throw new IllegalArgumentException("Treatment does not belong to user");
		}

		return reminderRepository.findByTreatment_Id(treatmentId).stream().map(this::toResponse).toList();
	}

	@Transactional(readOnly = true)
	public List<ReminderResponse> getUserReminders(UUID userId) {
		return reminderRepository.findByUserId(userId).stream().map(this::toResponse).toList();
	}

	@Transactional
	public ReminderResponse updateReminderStatus(UUID userId, UUID reminderId, ReminderStatus newStatus) {
		Reminder reminder = reminderRepository.findById(reminderId)
			.orElseThrow(() -> new NoSuchElementException("Reminder not found"));

		// Verify ownership
		if (!reminder.getTreatment().getPrescription().getUser().getId().equals(userId)) {
			throw new IllegalArgumentException("Reminder does not belong to user");
		}

		// If marking as TAKEN, consume the dosage from medicine stock
		if (newStatus == ReminderStatus.TAKEN && reminder.getStatus() != ReminderStatus.TAKEN) {
			consumeMedicineDosage(reminder);
		}

		reminder.setStatus(newStatus);
		Reminder updated = reminderRepository.save(reminder);

		log.info("Updated reminder {} status to {} for user {}", reminderId, newStatus, userId);
		return toResponse(updated);
	}

	private void consumeMedicineDosage(Reminder reminder) {
		Treatment treatment = reminder.getTreatment();
		MyMedicine myMedicine = treatment.getMyMedicine();

		// Parse dosage (e.g., "2" means 2 pills/tablets)
		int dosageAmount;
		try {
			dosageAmount = Integer.parseInt(treatment.getDosage().trim());
		}
		catch (NumberFormatException e) {
			log.warn("Could not parse dosage '{}' for treatment {}, defaulting to 1", treatment.getDosage(),
					treatment.getId());
			dosageAmount = 1;
		}

		// Create a consumption record (negative quantity)
		MedicinePurchaseHistory consumptionRecord = MedicinePurchaseHistory.builder()
			.quantityPurchased(-dosageAmount) // Negative for consumption
			.myMedicine(myMedicine)
			.build();

		myMedicine.getPurchaseHistory().add(consumptionRecord);

		log.info("Consumed {} units of medicine {} for reminder {}", dosageAmount, myMedicine.getName(),
				reminder.getId());
	}

	@Transactional(readOnly = true)
	public List<ReminderResponse> getTodaysReminders(UUID userId) {
		log.info("Getting today's reminders for user: {}", userId);
		return reminderRepository.findTodaysReminders()
			.stream()
			.filter(reminder -> reminder.getTreatment().getPrescription().getUser().getId().equals(userId))
			.map(this::toResponse)
			.toList();
	}

	@Transactional(readOnly = true)
	public List<ReminderResponse> getUpcomingReminders(UUID userId) {
		log.info("Getting upcoming reminders for user: {}", userId);
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime tomorrow = now.plusDays(1);

		return reminderRepository.findUpcomingReminders(now, tomorrow)
			.stream()
			.filter(reminder -> reminder.getTreatment().getPrescription().getUser().getId().equals(userId))
			.map(this::toResponse)
			.toList();
	}

	@Transactional(readOnly = true)
	public List<ReminderResponse> getUserRemindersByStatus(UUID userId, ReminderStatus status) {
		log.info("Getting reminders with status {} for user: {}", status, userId);
		return reminderRepository.findByUserId(userId)
			.stream()
			.filter(reminder -> reminder.getStatus() == status)
			.map(this::toResponse)
			.toList();
	}

	@Transactional
	public void deleteReminder(UUID userId, UUID reminderId) {
		log.info("Deleting reminder: {} by user: {}", reminderId, userId);

		Reminder reminder = reminderRepository.findById(reminderId)
			.orElseThrow(() -> new NoSuchElementException("Reminder not found"));

		// Verify ownership
		if (!reminder.getTreatment().getPrescription().getUser().getId().equals(userId)) {
			throw new IllegalArgumentException("Reminder does not belong to user");
		}

		reminderRepository.deleteById(reminderId);
		log.info("Reminder deleted: {} by user: {}", reminderId, userId);
	}
	// Add this method to ReminderService.java

	@Transactional(readOnly = true)
	public List<ReminderWithMedicationResponse> getRemindersWithMedications(UUID userId) {
		log.info("Getting all reminders with medication details for user: {}", userId);

		// Get all reminders for the user with medication and prescription details
		List<Reminder> allReminders = reminderRepository.findAllRemindersByUserIdWithDetails(userId);

		return allReminders.stream().map(reminder -> {
			Treatment treatment = reminder.getTreatment();
			MyMedicine myMedicine = treatment.getMyMedicine();
			Prescription prescription = treatment.getPrescription();

			return new ReminderWithMedicationResponse(reminder.getId(), myMedicine.getId(), myMedicine.getName(),
					prescription.getId(), prescription.getName(), reminder.getReminderDateTime(), reminder.getStatus(),
					reminder.getMessage(), reminder.getCreatedAt(), reminder.getUpdatedAt(), treatment.getId(),
					reminder.getTimeSlot());
		})
			.sorted((r1, r2) -> r1.getReminderTime().compareTo(r2.getReminderTime())) // Sort
																						// by
																						// reminder
																						// time
			.toList();
	}

	private ReminderResponse toResponse(Reminder reminder) {
		return new ReminderResponse(reminder.getId(), reminder.getReminderDateTime(), reminder.getStatus(),
				reminder.getMessage(), reminder.getCreatedAt(), reminder.getUpdatedAt(),
				reminder.getTreatment().getId(), reminder.getTimeSlot());
	}

}