package com.idvey.afya.security.service;

import com.idvey.afya.models.Reminder;
import com.idvey.afya.models.ReminderStatus;
import com.idvey.afya.models.Treatment;
import com.idvey.afya.payload.request.CreateReminderRequest;
import com.idvey.afya.payload.request.ReminderStartSuggestionRequest;
import com.idvey.afya.payload.response.CreateReminderBulkResponse;
import com.idvey.afya.payload.response.ReminderCreationSummary;
import com.idvey.afya.payload.response.ReminderResponse;
import com.idvey.afya.payload.response.ReminderStartSuggestion;
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
        LocalDate baseDate = calculateStartDate(now, request.getReminderTimes(), request.getStartPreference());

        // For each reminder day and each time slot, create a reminder
        for (Integer dayOffset : reminderDays) {
            LocalDate reminderDate = baseDate.plusDays(dayOffset);

            for (CreateReminderRequest.ReminderTimeSlot timeSlot : request.getReminderTimes()) {
                // Combine date with time to create full datetime
                LocalDateTime reminderDateTime = reminderDate.atTime(timeSlot.getTime());

                // Apply start preference logic for the first day only
                if (dayOffset == 0) {
                    reminderDateTime = applyStartPreference(reminderDateTime, now, request.getStartPreference(), timeSlot);
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

    private LocalDate calculateStartDate(LocalDateTime now, List<CreateReminderRequest.ReminderTimeSlot> timeSlots,
                                         CreateReminderRequest.StartPreference startPreference) {
        switch (startPreference) {
            case START_NOW:
                return now.toLocalDate();
            case START_TOMORROW:
                return now.toLocalDate().plusDays(1);
            case START_NEXT_CYCLE:
                // Find the next occurrence of the first time slot
                CreateReminderRequest.ReminderTimeSlot firstSlot = timeSlots.get(0);
                LocalDateTime nextOccurrence = now.toLocalDate().atTime(firstSlot.getTime());
                if (nextOccurrence.isBefore(now) || nextOccurrence.isEqual(now)) {
                    return now.toLocalDate().plusDays(1);
                }
                return now.toLocalDate();
            default:
                return now.toLocalDate();
        }
    }

    private LocalDateTime applyStartPreference(LocalDateTime reminderDateTime, LocalDateTime now,
                                               CreateReminderRequest.StartPreference startPreference,
                                               CreateReminderRequest.ReminderTimeSlot timeSlot) {
        return switch (startPreference) {
            case START_NOW -> {
                // If time has passed today, move to tomorrow
                if (reminderDateTime.isBefore(now)) {
                    yield reminderDateTime.plusDays(1);
                }
                yield reminderDateTime;
            }
            case START_TOMORROW ->
                // Always start tomorrow
                    reminderDateTime.plusDays(1);
            case START_NEXT_CYCLE -> {
                // Start from next occurrence of this time slot
                if (reminderDateTime.isBefore(now) || reminderDateTime.isEqual(now)) {
                    yield reminderDateTime.plusDays(1);
                }
                yield reminderDateTime;
            }
            default -> reminderDateTime;
        };
    }

    @Transactional(readOnly = true)
    public ReminderStartSuggestion getReminderStartSuggestions(ReminderStartSuggestionRequest request) {
        LocalDateTime now = LocalDateTime.now();
        LocalTime currentTime = now.toLocalTime();
        String currentPeriod = getCurrentPeriod(currentTime);

        List<ReminderStartSuggestion.StartOption> options = generateStartOptions(now, request.getReminderTimes());
        ReminderStartSuggestion.StartOption recommended = findRecommendedOption(options, currentTime, request.getReminderTimes());

        return new ReminderStartSuggestion(currentTime, currentPeriod, options, recommended);
    }

    private String getCurrentPeriod(LocalTime currentTime) {
        int hour = currentTime.getHour();
        if (hour >= 5 && hour < 12) return "morning";
        if (hour >= 12 && hour < 17) return "afternoon";
        if (hour >= 17 && hour < 21) return "evening";
        return "night";
    }

    private List<ReminderStartSuggestion.StartOption> generateStartOptions(LocalDateTime now,
                                                                           List<CreateReminderRequest.ReminderTimeSlot> timeSlots) {
        List<ReminderStartSuggestion.StartOption> options = new ArrayList<>();

        // Option 1: START_NOW
        LocalDateTime nextAvailableTime = findNextAvailableTime(now, timeSlots);
        options.add(new ReminderStartSuggestion.StartOption(
                CreateReminderRequest.StartPreference.START_NOW,
                "Start from today",
                nextAvailableTime,
                "Begin with the next scheduled time today, or tomorrow if all times have passed",
                false
        ));

        // Option 2: START_NEXT_CYCLE
        LocalDateTime nextCycleTime = findNextCycleTime(now, timeSlots);
        options.add(new ReminderStartSuggestion.StartOption(
                CreateReminderRequest.StartPreference.START_NEXT_CYCLE,
                "Start from next " + getTimeSlotName(timeSlots.get(0).getTimeSlot()),
                nextCycleTime,
                "Begin with the next occurrence of your first reminder time",
                true // This is usually the recommended option
        ));

        // Option 3: START_TOMORROW
        LocalDateTime tomorrowFirstTime = now.toLocalDate().plusDays(1).atTime(timeSlots.get(0).getTime());
        options.add(new ReminderStartSuggestion.StartOption(
                CreateReminderRequest.StartPreference.START_TOMORROW,
                "Start tomorrow",
                tomorrowFirstTime,
                "Begin fresh tomorrow with your first reminder time",
                false
        ));

        return options;
    }

    private LocalDateTime findNextAvailableTime(LocalDateTime now, List<CreateReminderRequest.ReminderTimeSlot> timeSlots) {
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
        CreateReminderRequest.ReminderTimeSlot firstSlot = timeSlots.get(0);
        LocalDateTime nextOccurrence = now.toLocalDate().atTime(firstSlot.getTime());

        if (nextOccurrence.isBefore(now) || nextOccurrence.isEqual(now)) {
            return nextOccurrence.plusDays(1);
        }
        return nextOccurrence;
    }

    private ReminderStartSuggestion.StartOption findRecommendedOption(List<ReminderStartSuggestion.StartOption> options,
                                                                      LocalTime currentTime,
                                                                      List<CreateReminderRequest.ReminderTimeSlot> timeSlots) {
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

    private String buildReminderMessage(Treatment treatment, CreateReminderRequest.ReminderTimeSlot timeSlot, String customMessage) {
        if (customMessage != null && !customMessage.trim().isEmpty()) {
            return customMessage;
        }

        String timeSlotName = getTimeSlotDisplayName(timeSlot.getTimeSlot());
        return String.format("Time to take your %s - %s (%s)",
                treatment.getMyMedicine().getName(),
                treatment.getDosage(),
                timeSlotName);
    }

    private String getTimeSlotDisplayName(CreateReminderRequest.TimeSlot timeSlot) {
        return switch (timeSlot) {
            case MORNING -> "Morning";
            case NOON -> "Noon";
            case EVENING -> "Evening";
            case NIGHT -> "Night";
        };
    }

    private CreateReminderBulkResponse buildBulkResponse(Treatment treatment, List<Reminder> savedReminders, CreateReminderRequest request) {
        // Convert to response DTOs
        List<ReminderResponse> reminderResponses = savedReminders.stream()
                .map(this::toResponse)
                .toList();

        // Build summary
        List<ReminderCreationSummary.TimeSlotSummary> timeSlotSummaries = request.getReminderTimes().stream()
                .map(timeSlot -> {
                    long count = savedReminders.stream()
                            .filter(r -> r.getTimeSlot() == timeSlot.getTimeSlot())
                            .count();
                    return new ReminderCreationSummary.TimeSlotSummary(
                            timeSlot.getTimeSlot(),
                            timeSlot.getTime(),
                            (int) count
                    );
                })
                .toList();

        ReminderCreationSummary summary = new ReminderCreationSummary(
                treatment.getDurationDays(),
                treatment.getFrequency(),
                timeSlotSummaries
        );

        String treatmentInfo = String.format("%s - %s %s for %d days",
                treatment.getMyMedicine().getName(),
                treatment.getDosage(),
                treatment.getFrequency(),
                treatment.getDurationDays());

        return new CreateReminderBulkResponse(
                treatment.getId(),
                treatmentInfo,
                savedReminders.size(),
                reminderResponses,
                summary
        );
    }

    @Transactional(readOnly = true)
    public List<ReminderResponse> getRemindersByTreatment(UUID userId, UUID treatmentId) {
        // Verify treatment belongs to user
        Treatment treatment = treatmentRepository.findById(treatmentId)
                .orElseThrow(() -> new NoSuchElementException("Treatment not found"));

        if (!treatment.getPrescription().getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Treatment does not belong to user");
        }

        return reminderRepository.findByTreatment_Id(treatmentId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<ReminderResponse> getUserReminders(UUID userId) {
        return reminderRepository.findByUserId(userId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional
    public ReminderResponse updateReminderStatus(UUID userId, UUID reminderId, ReminderStatus newStatus) {
        Reminder reminder = reminderRepository.findById(reminderId)
                .orElseThrow(() -> new NoSuchElementException("Reminder not found"));

        // Verify ownership
        if (!reminder.getTreatment().getPrescription().getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Reminder does not belong to user");
        }

        reminder.setStatus(newStatus);
        Reminder updated = reminderRepository.save(reminder);

        log.info("Updated reminder {} status to {} for user {}", reminderId, newStatus, userId);
        return toResponse(updated);
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

    private ReminderResponse toResponse(Reminder reminder) {
        return new ReminderResponse(
                reminder.getId(),
                reminder.getReminderDateTime(),
                reminder.getStatus(),
                reminder.getMessage(),
                reminder.getCreatedAt(),
                reminder.getUpdatedAt(),
                reminder.getTreatment().getId(),
                reminder.getTimeSlot()
        );
    }
}