package com.idvey.afya.controllers;

import com.idvey.afya.docs.GroupMedicalDocs;
import com.idvey.afya.payload.request.CreatePrescriptionRequest;
import com.idvey.afya.payload.request.CreateTreatmentRequest;
import com.idvey.afya.payload.request.UpdatePrescriptionRequest;
import com.idvey.afya.payload.request.UpdateTreatmentRequest;
import com.idvey.afya.payload.response.*;
import com.idvey.afya.security.service.GroupMedicalService;
import com.idvey.afya.security.service.UserDetailsImpl;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.nio.file.AccessDeniedException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/group-medical")
@RequiredArgsConstructor
@Tag(name = "Group Medical Management")
public class GroupMedicalController {

	private final GroupMedicalService groupMedicalService;

	// ============== PRESCRIPTION ENDPOINTS ==============

	@GroupMedicalDocs.GetUserPrescriptions
	@GetMapping("/groups/{groupId}/users/{userId}/prescriptions")
	public ResponseEntity<List<PrescriptionResponse>> getUserPrescriptions(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId, @PathVariable UUID userId)
			throws AccessDeniedException {
		List<PrescriptionResponse> prescriptions = groupMedicalService.getUserPrescriptions(currentUser.getId(),
				groupId, userId);
		return ResponseEntity.ok(prescriptions);
	}

	@GroupMedicalDocs.CreatePrescriptionForUser
	@PostMapping("/groups/{groupId}/users/{userId}/prescriptions")
	public ResponseEntity<PrescriptionResponse> createPrescriptionForUser(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId, @PathVariable UUID userId,
			@Valid @RequestBody CreatePrescriptionRequest request) throws AccessDeniedException {
		PrescriptionResponse response = groupMedicalService.createPrescriptionForUser(currentUser.getId(), groupId,
				userId, request);
		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}

	@GroupMedicalDocs.UpdateUserPrescription
	@PutMapping("/groups/{groupId}/users/{userId}/prescriptions/{prescriptionId}")
	public ResponseEntity<PrescriptionResponse> updateUserPrescription(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId, @PathVariable UUID userId,
			@PathVariable UUID prescriptionId, @Valid @RequestBody UpdatePrescriptionRequest request)
			throws AccessDeniedException {
		PrescriptionResponse response = groupMedicalService.updateUserPrescription(currentUser.getId(), groupId, userId,
				prescriptionId, request);
		return ResponseEntity.ok(response);
	}

	@GroupMedicalDocs.DeleteUserPrescription
	@DeleteMapping("/groups/{groupId}/users/{userId}/prescriptions/{prescriptionId}")
	public ResponseEntity<MessageResponse> deleteUserPrescription(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID groupId, @PathVariable UUID userId, @PathVariable UUID prescriptionId)
			throws AccessDeniedException {
		groupMedicalService.deleteUserPrescription(currentUser.getId(), groupId, userId, prescriptionId);
		return ResponseEntity.ok(new MessageResponse("Prescription deleted successfully"));
	}

	// ============== TREATMENT ENDPOINTS ==============

	@GroupMedicalDocs.GetUserTreatments
	@GetMapping("/groups/{groupId}/users/{userId}/treatments")
	public ResponseEntity<List<TreatmentResponse>> getAllUserTreatments(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId, @PathVariable UUID userId)
			throws AccessDeniedException {
		List<TreatmentResponse> treatments = groupMedicalService.getAllUserTreatments(currentUser.getId(), groupId,
				userId);
		return ResponseEntity.ok(treatments);
	}

	@GroupMedicalDocs.GetTreatmentsByPrescription
	@GetMapping("/groups/{groupId}/users/{userId}/prescriptions/{prescriptionId}/treatments")
	public ResponseEntity<List<TreatmentResponse>> getTreatmentsByPrescription(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId, @PathVariable UUID userId,
			@PathVariable UUID prescriptionId) throws AccessDeniedException {
		List<TreatmentResponse> treatments = groupMedicalService.getTreatmentsByPrescription(currentUser.getId(),
				groupId, userId, prescriptionId);
		return ResponseEntity.ok(treatments);
	}

	@GroupMedicalDocs.CreateTreatmentForUser
	@PostMapping("/groups/{groupId}/users/{userId}/treatments")
	public ResponseEntity<TreatmentResponse> createTreatmentForUser(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId, @PathVariable UUID userId,
			@Valid @RequestBody CreateTreatmentRequest request) throws AccessDeniedException {
		TreatmentResponse response = groupMedicalService.createTreatmentForUser(currentUser.getId(), groupId, userId,
				request);
		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}

	@GroupMedicalDocs.UpdateUserTreatment
	@PutMapping("/groups/{groupId}/users/{userId}/treatments/{treatmentId}")
	public ResponseEntity<TreatmentResponse> updateUserTreatment(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID groupId, @PathVariable UUID userId, @PathVariable UUID treatmentId,
			@Valid @RequestBody UpdateTreatmentRequest request) throws AccessDeniedException {
		TreatmentResponse response = groupMedicalService.updateUserTreatment(currentUser.getId(), groupId, userId,
				treatmentId, request);
		return ResponseEntity.ok(response);
	}

	@GroupMedicalDocs.DeleteUserTreatment
	@DeleteMapping("/groups/{groupId}/users/{userId}/treatments/{treatmentId}")
	public ResponseEntity<MessageResponse> deleteUserTreatment(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID groupId, @PathVariable UUID userId, @PathVariable UUID treatmentId)
			throws AccessDeniedException {
		groupMedicalService.deleteUserTreatment(currentUser.getId(), groupId, userId, treatmentId);
		return ResponseEntity.ok(new MessageResponse("Treatment deleted successfully"));
	}

	// ============== REMINDER ENDPOINTS ==============

	@GroupMedicalDocs.GetUserRemindersWithMedications
	@GetMapping("/groups/{groupId}/users/{userId}/reminders/with-medications")
	public ResponseEntity<List<ReminderWithMedicationResponse>> getUserRemindersWithMedications(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId, @PathVariable UUID userId)
			throws AccessDeniedException {
		List<ReminderWithMedicationResponse> reminders = groupMedicalService
			.getUserRemindersWithMedications(currentUser.getId(), groupId, userId);
		return ResponseEntity.ok(reminders);
	}

	@GroupMedicalDocs.GetUserReminders
	@GetMapping("/groups/{groupId}/users/{userId}/reminders")
	public ResponseEntity<List<ReminderResponse>> getUserReminders(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID groupId, @PathVariable UUID userId) throws AccessDeniedException {
		List<ReminderResponse> reminders = groupMedicalService.getUserReminders(currentUser.getId(), groupId, userId);
		return ResponseEntity.ok(reminders);
	}

	// ============== GROUP MEDICAL OVERVIEW ==============

	@GroupMedicalDocs.GetGroupMedicalOverview
	@GetMapping("/groups/{groupId}/medical-overview")
	public ResponseEntity<List<GroupMemberMedicalOverviewResponse>> getGroupMedicalOverview(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId)
			throws AccessDeniedException {
		List<GroupMemberMedicalOverviewResponse> overview = groupMedicalService
			.getGroupMedicalOverview(currentUser.getId(), groupId);
		return ResponseEntity.ok(overview);
	}

	@GroupMedicalDocs.GetUserMedicalSummary
	@GetMapping("/groups/{groupId}/users/{userId}/medical-summary")
	public ResponseEntity<UserMedicalSummaryResponse> getUserMedicalSummary(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID groupId, @PathVariable UUID userId)
			throws AccessDeniedException {
		UserMedicalSummaryResponse summary = groupMedicalService.getUserMedicalSummary(currentUser.getId(), groupId,
				userId);
		return ResponseEntity.ok(summary);
	}

}