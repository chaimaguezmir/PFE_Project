package com.idvey.afya.security.service;

import com.idvey.afya.models.*;
import com.idvey.afya.models.groupe.GroupMember;
import com.idvey.afya.models.groupe.GroupRole;
import com.idvey.afya.payload.request.CreatePrescriptionRequest;
import com.idvey.afya.payload.request.CreateReminderRequest;
import com.idvey.afya.payload.request.CreateTreatmentRequest;
import com.idvey.afya.payload.request.UpdatePrescriptionRequest;
import com.idvey.afya.payload.request.UpdateTreatmentRequest;
import com.idvey.afya.payload.response.*;
import com.idvey.afya.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.AccessDeniedException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class GroupMedicalService {

	private final GroupMemberRepository groupMemberRepository;

	private final UserRepository userRepository;

	private final PrescriptionRepository prescriptionRepository;

	private final TreatmentRepository treatmentRepository;

	private final ReminderRepository reminderRepository;

	private final DiseaseRepository diseaseRepository;

	private final MyMedicineRepository myMedicineRepository;

	private final PrescriptionService prescriptionService;

	private final ReminderService reminderService;

	// ============== AUTHORIZATION HELPER METHODS ==============

	/**
	 * Validates if the current user has MANAGER or RESPONSIBLE permissions for the target
	 * user
	 */
	private void validateManagerOrResponsibleAccess(UUID currentUserId, UUID groupId, UUID targetUserId)
			throws AccessDeniedException {

		// Check if current user is MANAGER or RESPONSIBLE in the group
		GroupMember currentMember = groupMemberRepository.findByGroup_IdAndUser_Id(groupId, currentUserId)
			.orElseThrow(() -> new AccessDeniedException("You are not a member of this group"));

		if (currentMember.getRole() != GroupRole.MANAGER && currentMember.getRole() != GroupRole.RESPONSIBLE) {
			throw new AccessDeniedException(
					"Insufficient permissions. Only MANAGERS and RESPONSIBLES can access other users' medical data");
		}

		// Check if target user is in the same group
		boolean targetInGroup = groupMemberRepository.existsByUser_IdAndGroup_Id(targetUserId, groupId);
		if (!targetInGroup) {
			throw new AccessDeniedException("Target user is not a member of this group");
		}

		log.info("Access validated: User {} ({}) accessing medical data for user {} in group {}", currentUserId,
				currentMember.getRole(), targetUserId, groupId);
	}

	/**
	 * Validates MANAGER-only access for delete operations
	 */
	private void validateManagerOnlyAccess(UUID currentUserId, UUID groupId, UUID targetUserId)
			throws AccessDeniedException {

		GroupMember currentMember = groupMemberRepository.findByGroup_IdAndUser_Id(groupId, currentUserId)
			.orElseThrow(() -> new AccessDeniedException("You are not a member of this group"));

		if (currentMember.getRole() != GroupRole.MANAGER) {
			throw new AccessDeniedException("Insufficient permissions. Only MANAGERS can delete medical data");
		}

		// Check if target user is in the same group
		boolean targetInGroup = groupMemberRepository.existsByUser_IdAndGroup_Id(targetUserId, groupId);
		if (!targetInGroup) {
			throw new AccessDeniedException("Target user is not a member of this group");
		}

		log.info("Manager access validated: User {} accessing medical data for user {} in group {}", currentUserId,
				targetUserId, groupId);
	}

	// ============== PRESCRIPTION MANAGEMENT ==============

	@Transactional(readOnly = true)
	public List<PrescriptionResponse> getUserPrescriptions(UUID currentUserId, UUID groupId, UUID targetUserId)
			throws AccessDeniedException {
		log.info("Getting prescriptions for user {} by user {} in group {}", targetUserId, currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		return prescriptionRepository.findByUserIdOrderByCreatedAtDesc(targetUserId)
			.stream()
			.map(this::toPrescriptionResponse)
			.toList();
	}

	@Transactional
	public PrescriptionResponse createPrescriptionForUser(UUID currentUserId, UUID groupId, UUID targetUserId,
			CreatePrescriptionRequest request) throws AccessDeniedException {
		log.info("Creating prescription for user {} by user {} in group {}", targetUserId, currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		User targetUser = userRepository.findById(targetUserId)
			.orElseThrow(() -> new NoSuchElementException("Target user not found"));

		// Get diseases
		Set<Disease> diseases = request.getDiseaseIds()
			.stream()
			.map(id -> diseaseRepository.findById(id)
				.orElseThrow(() -> new NoSuchElementException("Disease not found with ID: " + id)))
			.collect(Collectors.toSet());

		// Create prescription
		Prescription prescription = Prescription.builder()
			.name(request.getName())
			.startDate(LocalDate.now())
			.endDate(null)
			.user(targetUser)
			.diseases(diseases)
			.build();

		Prescription saved = prescriptionRepository.save(prescription);
		log.info("Prescription created with ID: {} for user {} by user {}", saved.getId(), targetUserId, currentUserId);

		return toPrescriptionResponse(saved);
	}

	@Transactional
	public PrescriptionResponse updateUserPrescription(UUID currentUserId, UUID groupId, UUID targetUserId,
			UUID prescriptionId, UpdatePrescriptionRequest request) throws AccessDeniedException {
		log.info("Updating prescription {} for user {} by user {} in group {}", prescriptionId, targetUserId,
				currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		Prescription prescription = prescriptionRepository.findById(prescriptionId)
			.orElseThrow(() -> new NoSuchElementException("Prescription not found"));

		// Verify prescription belongs to target user
		if (!prescription.getUser().getId().equals(targetUserId)) {
			throw new IllegalArgumentException("Prescription does not belong to target user");
		}

		// Update diseases
		Set<Disease> diseases = request.getDiseaseIds()
			.stream()
			.map(id -> diseaseRepository.findById(id)
				.orElseThrow(() -> new NoSuchElementException("Disease not found with ID: " + id)))
			.collect(Collectors.toSet());

		prescription.setName(request.getName());
		prescription.setDiseases(diseases);

		Prescription updated = prescriptionRepository.save(prescription);
		log.info("Prescription updated: {} for user {} by user {}", prescriptionId, targetUserId, currentUserId);

		return toPrescriptionResponse(updated);
	}

	@Transactional
	public void deleteUserPrescription(UUID currentUserId, UUID groupId, UUID targetUserId, UUID prescriptionId)
			throws AccessDeniedException {
		log.info("Deleting prescription {} for user {} by user {} in group {}", prescriptionId, targetUserId,
				currentUserId, groupId);

		// Only MANAGERS can delete prescriptions
		validateManagerOnlyAccess(currentUserId, groupId, targetUserId);

		Prescription prescription = prescriptionRepository.findById(prescriptionId)
			.orElseThrow(() -> new NoSuchElementException("Prescription not found"));

		// Verify prescription belongs to target user
		if (!prescription.getUser().getId().equals(targetUserId)) {
			throw new IllegalArgumentException("Prescription does not belong to target user");
		}

		prescriptionRepository.deleteById(prescriptionId);
		log.info("Prescription deleted: {} for user {} by user {}", prescriptionId, targetUserId, currentUserId);
	}

	// ============== TREATMENT MANAGEMENT ==============

	@Transactional(readOnly = true)
	public List<TreatmentResponse> getAllUserTreatments(UUID currentUserId, UUID groupId, UUID targetUserId)
			throws AccessDeniedException {
		log.info("Getting all treatments for user {} by user {} in group {}", targetUserId, currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		return treatmentRepository.findAllByUserId(targetUserId).stream().map(this::toTreatmentResponse).toList();
	}

	@Transactional(readOnly = true)
	public List<TreatmentResponse> getTreatmentsByPrescription(UUID currentUserId, UUID groupId, UUID targetUserId,
			UUID prescriptionId) throws AccessDeniedException {
		log.info("Getting treatments for prescription {} of user {} by user {} in group {}", prescriptionId,
				targetUserId, currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		// Verify prescription belongs to target user
		Prescription prescription = prescriptionRepository.findById(prescriptionId)
			.orElseThrow(() -> new NoSuchElementException("Prescription not found"));

		if (!prescription.getUser().getId().equals(targetUserId)) {
			throw new IllegalArgumentException("Prescription does not belong to target user");
		}

		return treatmentRepository.findByPrescriptionIdOrderByCreatedAtDesc(prescriptionId)
			.stream()
			.map(this::toTreatmentResponse)
			.toList();
	}

	@Transactional
	public TreatmentResponse createTreatmentForUser(UUID currentUserId, UUID groupId, UUID targetUserId,
			CreateTreatmentRequest request) throws AccessDeniedException {
		log.info("Creating treatment for user {} by user {} in group {}", targetUserId, currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		Prescription prescription = prescriptionRepository.findById(request.getPrescriptionId())
			.orElseThrow(() -> new NoSuchElementException("Prescription not found"));

		// Verify prescription belongs to target user
		if (!prescription.getUser().getId().equals(targetUserId)) {
			throw new IllegalArgumentException("Prescription does not belong to target user");
		}

		MyMedicine myMedicine = myMedicineRepository.findById(request.getMyMedicineId())
			.orElseThrow(() -> new NoSuchElementException("MyMedicine not found"));

		Treatment treatment = Treatment.builder()
			.dosage(request.getDosage())
			.frequency(request.getFrequency())
			.durationDays(request.getDurationDays())
			.prescription(prescription)
			.myMedicine(myMedicine)
			.build();

		Treatment saved = treatmentRepository.save(treatment);
		log.info("Treatment created with ID: {} for user {} by user {}", saved.getId(), targetUserId, currentUserId);

		// Update prescription end date
		prescriptionService.updatePrescriptionEndDate(prescription.getId());

		return toTreatmentResponse(saved);
	}

	@Transactional
	public TreatmentResponse updateUserTreatment(UUID currentUserId, UUID groupId, UUID targetUserId, UUID treatmentId,
			UpdateTreatmentRequest request) throws AccessDeniedException {
		log.info("Updating treatment {} for user {} by user {} in group {}", treatmentId, targetUserId, currentUserId,
				groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		Treatment treatment = treatmentRepository.findById(treatmentId)
			.orElseThrow(() -> new NoSuchElementException("Treatment not found"));

		// Verify treatment belongs to target user
		if (!treatment.getPrescription().getUser().getId().equals(targetUserId)) {
			throw new IllegalArgumentException("Treatment does not belong to target user");
		}

		treatment.setDosage(request.getDosage());
		treatment.setFrequency(request.getFrequency());
		treatment.setDurationDays(request.getDurationDays());

		Treatment updated = treatmentRepository.save(treatment);
		log.info("Treatment updated: {} for user {} by user {}", treatmentId, targetUserId, currentUserId);

		// Update prescription end date
		prescriptionService.updatePrescriptionEndDate(treatment.getPrescription().getId());

		return toTreatmentResponse(updated);
	}

	@Transactional
	public void deleteUserTreatment(UUID currentUserId, UUID groupId, UUID targetUserId, UUID treatmentId)
			throws AccessDeniedException {
		log.info("Deleting treatment {} for user {} by user {} in group {}", treatmentId, targetUserId, currentUserId,
				groupId);

		// Only MANAGERS can delete treatments
		validateManagerOnlyAccess(currentUserId, groupId, targetUserId);

		Treatment treatment = treatmentRepository.findById(treatmentId)
			.orElseThrow(() -> new NoSuchElementException("Treatment not found"));

		// Verify treatment belongs to target user
		if (!treatment.getPrescription().getUser().getId().equals(targetUserId)) {
			throw new IllegalArgumentException("Treatment does not belong to target user");
		}

		UUID prescriptionId = treatment.getPrescription().getId();
		treatmentRepository.deleteById(treatmentId);
		log.info("Treatment deleted: {} for user {} by user {}", treatmentId, targetUserId, currentUserId);

		// Update prescription end date
		prescriptionService.updatePrescriptionEndDate(prescriptionId);
	}

	// ============== REMINDER MANAGEMENT ==============

	@Transactional(readOnly = true)
	public List<ReminderWithMedicationResponse> getUserRemindersWithMedications(UUID currentUserId, UUID groupId,
			UUID targetUserId) throws AccessDeniedException {
		log.info("Getting reminders with medications for user {} by user {} in group {}", targetUserId, currentUserId,
				groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		// Get all reminders for the target user with medication and prescription details
		List<Reminder> allReminders = reminderRepository.findAllRemindersByUserIdWithDetails(targetUserId);

		return allReminders.stream().map(reminder -> {
			Treatment treatment = reminder.getTreatment();
			MyMedicine myMedicine = treatment.getMyMedicine();
			Prescription prescription = treatment.getPrescription();

			return new ReminderWithMedicationResponse(reminder.getId(), myMedicine.getId(), myMedicine.getName(),
					prescription.getId(), prescription.getName(), reminder.getReminderDateTime(), reminder.getStatus(),
					reminder.getMessage(), reminder.getCreatedAt(), reminder.getUpdatedAt(), treatment.getId(),
					reminder.getTimeSlot());
		}).sorted((r1, r2) -> r1.getReminderTime().compareTo(r2.getReminderTime())).toList();
	}

	@Transactional(readOnly = true)
	public List<ReminderResponse> getUserReminders(UUID currentUserId, UUID groupId, UUID targetUserId)
			throws AccessDeniedException {
		log.info("Getting reminders for user {} by user {} in group {}", targetUserId, currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		return reminderRepository.findByUserId(targetUserId).stream().map(this::toReminderResponse).toList();
	}

	@Transactional
	public ReminderResponse markUserReminderAsTaken(UUID currentUserId, UUID groupId, UUID targetUserId,
			UUID reminderId) throws AccessDeniedException {
		log.info("Marking reminder {} as taken for user {} by user {} in group {}", reminderId, targetUserId,
				currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		// Delegate to ReminderService to update the reminder status
		// This reuses all the existing logic including dosage consumption
		ReminderResponse updatedReminder = reminderService.updateReminderStatus(targetUserId, reminderId,
				ReminderStatus.TAKEN);

		log.info("Successfully marked reminder {} as taken for user {} by caregiver {}", reminderId, targetUserId,
				currentUserId);

		return updatedReminder;
	}

	@Transactional
	public CreateReminderBulkResponse createRemindersForUser(UUID currentUserId, UUID groupId, UUID targetUserId,
			CreateReminderRequest request) throws AccessDeniedException {
		log.info("Creating reminders for user {} by user {} in group {}", targetUserId, currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		// Get and validate treatment
		Treatment treatment = treatmentRepository.findById(request.getTreatmentId())
			.orElseThrow(() -> new NoSuchElementException("Treatment not found"));

		// Verify treatment belongs to target user
		if (!treatment.getPrescription().getUser().getId().equals(targetUserId)) {
			throw new IllegalArgumentException("Treatment does not belong to target user");
		}

		// Delegate to reminderService with target user's ID
		CreateReminderBulkResponse response = reminderService.createRemindersForTreatment(targetUserId, request);

		log.info("Successfully created {} reminders for user {} by user {}", response.getTotalRemindersCreated(),
				targetUserId, currentUserId);

		return response;
	}

	// ============== GROUP OVERVIEW METHODS ==============

	@Transactional(readOnly = true)
	public List<GroupMemberMedicalOverviewResponse> getGroupMedicalOverview(UUID currentUserId, UUID groupId)
			throws AccessDeniedException {
		log.info("Getting group medical overview for group {} by user {}", groupId, currentUserId);

		// Validate current user is MANAGER or RESPONSIBLE
		GroupMember currentMember = groupMemberRepository.findByGroup_IdAndUser_Id(groupId, currentUserId)
			.orElseThrow(() -> new AccessDeniedException("You are not a member of this group"));

		if (currentMember.getRole() != GroupRole.MANAGER && currentMember.getRole() != GroupRole.RESPONSIBLE) {
			throw new AccessDeniedException(
					"Insufficient permissions. Only MANAGERS and RESPONSIBLES can view group medical overview");
		}

		// Get all group members
		List<GroupMember> groupMembers = groupMemberRepository.findAllByGroupIdWithUser(groupId);

		return groupMembers.stream().map(member -> {
			User user = member.getUser();
			UUID userId = user.getId();

			// Get medical statistics
			List<Prescription> prescriptions = prescriptionRepository.findByUser_Id(userId);
			List<Prescription> activePrescriptions = prescriptionRepository.findActiveByUserId(userId, LocalDate.now());
			long totalTreatments = treatmentRepository.countByUserId(userId);
			List<Reminder> allReminders = reminderRepository.findByUserId(userId);
			long pendingReminders = allReminders.stream()
				.filter(r -> r.getStatus() == ReminderStatus.SCHEDULED || r.getStatus() == ReminderStatus.ACTIVE)
				.count();

			// Get last activity dates
			LocalDateTime lastPrescriptionDate = prescriptions.stream()
				.map(Prescription::getCreatedAt)
				.max(LocalDateTime::compareTo)
				.orElse(null);

			LocalDateTime lastTreatmentDate = treatmentRepository.findAllByUserId(userId)
				.stream()
				.map(Treatment::getCreatedAt)
				.max(LocalDateTime::compareTo)
				.orElse(null);

			LocalDateTime lastReminderDate = allReminders.stream()
				.map(Reminder::getCreatedAt)
				.max(LocalDateTime::compareTo)
				.orElse(null);

			return new GroupMemberMedicalOverviewResponse(userId, user.getUsername(), user.getEmail(),
					user.getFirstName(), user.getLastName(), member.getRole(), activePrescriptions.size(),
					(int) totalTreatments, allReminders.size(), (int) pendingReminders, lastPrescriptionDate,
					lastTreatmentDate, lastReminderDate, user.getBloodGroup(), user.getGender(), user.getWeight(),
					user.getHeight());
		}).toList();
	}

	@Transactional(readOnly = true)
	public UserMedicalSummaryResponse getUserMedicalSummary(UUID currentUserId, UUID groupId, UUID targetUserId)
			throws AccessDeniedException {
		log.info("Getting medical summary for user {} by user {} in group {}", targetUserId, currentUserId, groupId);

		validateManagerOrResponsibleAccess(currentUserId, groupId, targetUserId);

		User targetUser = userRepository.findById(targetUserId)
			.orElseThrow(() -> new NoSuchElementException("Target user not found"));

		GroupMember targetMember = groupMemberRepository.findByGroup_IdAndUser_Id(groupId, targetUserId)
			.orElseThrow(() -> new NoSuchElementException("Target user not found in group"));

		// Build health profile
		UserHealthProfileResponse healthProfile = new UserHealthProfileResponse(targetUser.getWeight(),
				targetUser.getHeight(), targetUser.getBloodGroup(), targetUser.getGender(), targetUser.getBirthDate(),
				targetUser.isSmokingStatus(), targetUser.isAlcoholConsumption(), targetUser.isExerciseRegularly(),
				targetUser.isFamilyHistoryHeartDisease(), targetUser.isHypertensionHistory(),
				targetUser.isHeartDisease(), targetUser.isDiabetes(), targetUser.isCholesterol(),
				targetUser.isAllergies());

		// Build medical summary
		List<Prescription> allPrescriptions = prescriptionRepository.findByUser_Id(targetUserId);
		List<Prescription> activePrescriptions = prescriptionRepository.findActiveByUserId(targetUserId,
				LocalDate.now());
		List<Treatment> allTreatments = treatmentRepository.findAllByUserId(targetUserId);
		List<Reminder> allReminders = reminderRepository.findByUserId(targetUserId);

		MedicalSummaryResponse medicalSummary = buildMedicalSummary(allPrescriptions, activePrescriptions,
				allTreatments, allReminders);

		// Get recent data
		List<PrescriptionResponse> recentPrescriptions = allPrescriptions.stream()
			.sorted((p1, p2) -> p2.getCreatedAt().compareTo(p1.getCreatedAt()))
			.limit(5)
			.map(this::toPrescriptionResponse)
			.toList();

		List<TreatmentResponse> recentTreatments = allTreatments.stream()
			.sorted((t1, t2) -> t2.getCreatedAt().compareTo(t1.getCreatedAt()))
			.limit(5)
			.map(this::toTreatmentResponse)
			.toList();

		List<ReminderResponse> upcomingReminders = allReminders.stream()
			.filter(r -> r.getReminderDateTime().isAfter(LocalDateTime.now()))
			.sorted((r1, r2) -> r1.getReminderDateTime().compareTo(r2.getReminderDateTime()))
			.limit(10)
			.map(this::toReminderResponse)
			.toList();

		return new UserMedicalSummaryResponse(targetUserId, targetUser.getUsername(), targetUser.getEmail(),
				targetUser.getFirstName(), targetUser.getLastName(), targetUser.getPhoneNumber(),
				targetMember.getRole(), healthProfile, medicalSummary, recentPrescriptions, recentTreatments,
				upcomingReminders);
	}

	// ============== HELPER METHODS ==============

	private UserBasicInfoResponse createUserBasicInfo(User user, GroupRole role) {
		return new UserBasicInfoResponse(user.getId(), user.getUsername(), user.getEmail(), user.getFirstName(),
				user.getLastName(), role);
	}

	private MedicalSummaryResponse buildMedicalSummary(List<Prescription> allPrescriptions,
			List<Prescription> activePrescriptions, List<Treatment> allTreatments, List<Reminder> allReminders) {

		// Calculate treatment stats
		long activeTreatments = allTreatments.stream().filter(t -> {
			LocalDate treatmentEndDate = t.getCreatedAt().toLocalDate().plusDays(t.getDurationDays());
			return treatmentEndDate.isAfter(LocalDate.now()) || treatmentEndDate.equals(LocalDate.now());
		}).count();

		// Calculate reminder stats
		long scheduledReminders = allReminders.stream().filter(r -> r.getStatus() == ReminderStatus.SCHEDULED).count();
		long takenReminders = allReminders.stream().filter(r -> r.getStatus() == ReminderStatus.TAKEN).count();
		long missedReminders = allReminders.stream().filter(r -> r.getStatus() == ReminderStatus.MISSED).count();
		long pendingReminders = allReminders.stream()
			.filter(r -> r.getStatus() == ReminderStatus.ACTIVE || r.getStatus() == ReminderStatus.SCHEDULED)
			.count();

		// Get timeline info
		LocalDateTime firstPrescriptionDate = allPrescriptions.stream()
			.map(Prescription::getCreatedAt)
			.min(LocalDateTime::compareTo)
			.orElse(null);

		LocalDateTime lastPrescriptionDate = allPrescriptions.stream()
			.map(Prescription::getCreatedAt)
			.max(LocalDateTime::compareTo)
			.orElse(null);

		LocalDateTime lastActivityDate = List
			.of(allPrescriptions.stream()
				.map(Prescription::getUpdatedAt)
				.max(LocalDateTime::compareTo)
				.orElse(LocalDateTime.MIN),
					allTreatments.stream()
						.map(Treatment::getUpdatedAt)
						.max(LocalDateTime::compareTo)
						.orElse(LocalDateTime.MIN),
					allReminders.stream()
						.map(Reminder::getUpdatedAt)
						.max(LocalDateTime::compareTo)
						.orElse(LocalDateTime.MIN))
			.stream()
			.max(LocalDateTime::compareTo)
			.orElse(null);

		return new MedicalSummaryResponse(allPrescriptions.size(), activePrescriptions.size(),
				allPrescriptions.size() - activePrescriptions.size(), allTreatments.size(), (int) activeTreatments,
				allTreatments.size() - (int) activeTreatments, allReminders.size(), (int) scheduledReminders,
				(int) takenReminders, (int) missedReminders, (int) pendingReminders, firstPrescriptionDate,
				lastPrescriptionDate, lastActivityDate);
	}

	// ============== MAPPING METHODS ==============

	private PrescriptionResponse toPrescriptionResponse(Prescription prescription) {
		return new PrescriptionResponse(prescription.getId(), prescription.getName(), prescription.getStartDate(),
				prescription.getEndDate(), prescription.getCreatedAt(), prescription.getUpdatedAt(),
				prescription.getDiseases()
					.stream()
					.map(d -> new DiseaseResponse(d.getId(), d.getName(), d.getPrescriptions().size()))
					.toList(),
				prescription.getTreatments().size());
	}

	private TreatmentResponse toTreatmentResponse(Treatment treatment) {
		return new TreatmentResponse(treatment.getId(), treatment.getDosage(), treatment.getFrequency(),
				treatment.getDurationDays(), treatment.getCreatedAt(), treatment.getUpdatedAt(),
				treatment.getPrescription().getId(), treatment.getPrescription().getName(),
				toMyMedicineResponse(treatment.getMyMedicine()));
	}

	private ReminderResponse toReminderResponse(Reminder reminder) {
		return new ReminderResponse(reminder.getId(), reminder.getReminderDateTime(), reminder.getStatus(),
				reminder.getMessage(), reminder.getCreatedAt(), reminder.getUpdatedAt(),
				reminder.getTreatment().getId(), reminder.getTimeSlot());
	}

	private MyMedicineResponse toMyMedicineResponse(MyMedicine myMedicine) {
		MedicineResponse medicineResponse = null;
		if (myMedicine.getMedicine() != null) {
			medicineResponse = new MedicineResponse(myMedicine.getMedicine().getId(),
					myMedicine.getMedicine().getMedicationName(), myMedicine.getMedicine().getDosage(),
					myMedicine.getMedicine().getForm(), myMedicine.getMedicine().getPresentation(),
					myMedicine.getMedicine().getDci(), myMedicine.getMedicine().getTherapeuticClass(),
					myMedicine.getMedicine().getSubClass(), myMedicine.getMedicine().getLaboratory(),
					myMedicine.getMedicine().getAmmNumber(), myMedicine.getMedicine().getAmmDate(),
					myMedicine.getMedicine().getPrimaryPackaging(),
					myMedicine.getMedicine().getPackagingSpecification(),
					myMedicine.getMedicine().getScheduleCategory(), myMedicine.getMedicine().getShelfLife(),
					myMedicine.getMedicine().getIndications(), myMedicine.getMedicine().getMedicationType(),
					myMedicine.getMedicine().getVeicClassification(), myMedicine.getMedicine().getBarcode(),
					myMedicine.getMedicine().isRequiresPrescription());
		}

		return new MyMedicineResponse(myMedicine.getId(), myMedicine.getName(), myMedicine.getForm(),
				myMedicine.getPharmacyBox().getId(), myMedicine.getPharmacyBox().getGroup().getName(), medicineResponse,
				myMedicine.isCustomMedicine(), myMedicine.getCustomManufacturer(), myMedicine.getCustomForm(),
				myMedicine.getCustomRequiresPrescription(), 0, // totalQuantityPurchased -
																// can be calculated if
																// needed
				0, // purchaseHistoryCount - can be calculated if needed
				myMedicine.getCreatedAt(), myMedicine.getUpdatedAt());
	}

}