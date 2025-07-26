package com.idvey.afya.controllers;

import com.idvey.afya.docs.ReminderDocs;
import com.idvey.afya.models.ReminderStatus;
import com.idvey.afya.payload.request.CreateReminderRequest;
import com.idvey.afya.payload.request.ReminderStartSuggestionRequest;
import com.idvey.afya.payload.request.UpdateReminderStatusRequest;
import com.idvey.afya.payload.response.CreateReminderBulkResponse;
import com.idvey.afya.payload.response.MessageResponse;
import com.idvey.afya.payload.response.ReminderResponse;
import com.idvey.afya.payload.response.ReminderStartSuggestion;
import com.idvey.afya.security.service.ReminderService;
import com.idvey.afya.security.service.UserDetailsImpl;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/reminders")
@RequiredArgsConstructor
@Tag(name = "Reminders")
public class ReminderController {

	private final ReminderService reminderService;

	@ReminderDocs.GetStartSuggestions
	@PostMapping("/start-suggestions")
	public ResponseEntity<ReminderStartSuggestion> getStartSuggestions(
			@AuthenticationPrincipal UserDetailsImpl currentUser,
			@Valid @RequestBody ReminderStartSuggestionRequest request) {
		ReminderStartSuggestion suggestions = reminderService.getReminderStartSuggestions(request);
		return ResponseEntity.ok(suggestions);
	}

	@ReminderDocs.CreateReminders
	@PostMapping
	public ResponseEntity<CreateReminderBulkResponse> createReminders(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @Valid @RequestBody CreateReminderRequest request) {
		CreateReminderBulkResponse response = reminderService.createRemindersForTreatment(currentUser.getId(), request);
		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}

	@ReminderDocs.GetUserReminders
	@GetMapping
	public ResponseEntity<List<ReminderResponse>> getUserReminders(
			@AuthenticationPrincipal UserDetailsImpl currentUser) {
		List<ReminderResponse> reminders = reminderService.getUserReminders(currentUser.getId());
		return ResponseEntity.ok(reminders);
	}

	@ReminderDocs.GetRemindersByTreatment
	@GetMapping("/treatment/{treatmentId}")
	public ResponseEntity<List<ReminderResponse>> getRemindersByTreatment(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID treatmentId) {
		List<ReminderResponse> reminders = reminderService.getRemindersByTreatment(currentUser.getId(), treatmentId);
		return ResponseEntity.ok(reminders);
	}

	@ReminderDocs.UpdateReminderStatus
	@PutMapping("/{reminderId}/status")
	public ResponseEntity<ReminderResponse> updateReminderStatus(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID reminderId, @Valid @RequestBody UpdateReminderStatusRequest request) {
		ReminderResponse response = reminderService.updateReminderStatus(currentUser.getId(), reminderId,
				request.getStatus());
		return ResponseEntity.ok(response);
	}

	@ReminderDocs.GetRemindersByStatus
	@GetMapping("/status/{status}")
	public ResponseEntity<List<ReminderResponse>> getRemindersByStatus(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable ReminderStatus status) {
		List<ReminderResponse> reminders = reminderService.getUserRemindersByStatus(currentUser.getId(), status);
		return ResponseEntity.ok(reminders);
	}

	@ReminderDocs.GetTodaysReminders
	@GetMapping("/today")
	public ResponseEntity<List<ReminderResponse>> getTodaysReminders(
			@AuthenticationPrincipal UserDetailsImpl currentUser) {
		List<ReminderResponse> reminders = reminderService.getTodaysReminders(currentUser.getId());
		return ResponseEntity.ok(reminders);
	}

	@ReminderDocs.GetUpcomingReminders
	@GetMapping("/upcoming")
	public ResponseEntity<List<ReminderResponse>> getUpcomingReminders(
			@AuthenticationPrincipal UserDetailsImpl currentUser) {
		List<ReminderResponse> reminders = reminderService.getUpcomingReminders(currentUser.getId());
		return ResponseEntity.ok(reminders);
	}

	@ReminderDocs.DeleteReminder
	@DeleteMapping("/{reminderId}")
	public ResponseEntity<MessageResponse> deleteReminder(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID reminderId) {
		reminderService.deleteReminder(currentUser.getId(), reminderId);
		return ResponseEntity.ok(new MessageResponse("Reminder deleted successfully"));
	}

}