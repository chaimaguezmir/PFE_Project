package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.lang.annotation.*;

@Tag(name = "Reminders",
		description = "Medicine reminder management - Create, track, and update medication reminders with smart date-time scheduling")
public final class ReminderDocs {

	private ReminderDocs() {
	} // no instantiation

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get reminder start suggestions",
			description = "Provides smart suggestions for when to start reminders based on current time and selected time slots. "
					+ "**Example scenarios:** " + "• Current time: 10:00 AM, reminder times: 8:00 AM, 6:00 PM "
					+ "• Options: Start today (6:00 PM), Start next morning (tomorrow 8:00 AM), Start tomorrow "
					+ "**Helps users choose:** START_NOW, START_NEXT_CYCLE, or START_TOMORROW")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Start suggestions generated successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.ReminderStartSuggestion.class))),
			@ApiResponse(responseCode = "400", description = "Invalid reminder times provided"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetStartSuggestions {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Create reminders for treatment",
			description = "Automatically creates multiple reminders with full date-time scheduling based on treatment frequency, duration, and specified time slots. "
					+ "**Smart Scheduling:** If reminder time has already passed today, it starts from tomorrow. "
					+ "**Examples:** "
					+ "• Daily treatment for 7 days with morning (8:00) and evening (18:00) = 14 reminders "
					+ "• Every other day for 7 days with noon (12:00) = 4 reminders "
					+ "**Date Progression:** 2025-07-21T08:00, 2025-07-22T08:00, 2025-07-23T08:00...")
	@ApiResponses({
			@ApiResponse(responseCode = "201", description = "Reminders created successfully",
					content = @Content(mediaType = "application/json", schema = @Schema(
							implementation = com.idvey.afya.payload.response.CreateReminderBulkResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data or treatment not found"),
			@ApiResponse(responseCode = "403", description = "Access denied - treatment belongs to another user"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface CreateReminders {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get user's reminders",
			description = "Retrieves all reminders for the authenticated user across all treatments, ordered by reminder date-time. "
					+ "Each reminder includes full date-time (e.g., 2025-07-21T08:00:00) for accurate scheduling.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Reminders retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.ReminderResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetUserReminders {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get today's reminders",
			description = "Retrieves all reminders scheduled for today for the authenticated user. "
					+ "Perfect for daily reminder dashboard showing what medications to take today.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Today's reminders retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.ReminderResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetTodaysReminders {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get upcoming reminders",
			description = "Retrieves reminders scheduled for the next 24 hours for the authenticated user. "
					+ "Useful for showing upcoming medications and preparing notifications.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Upcoming reminders retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.ReminderResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetUpcomingReminders {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get reminders by treatment",
			description = "Retrieves all reminders for a specific treatment with full date-time information. "
					+ "Shows the complete medication schedule for a particular treatment. User must own the treatment.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Treatment reminders retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.ReminderResponse.class))),
			@ApiResponse(responseCode = "404", description = "Treatment not found"),
			@ApiResponse(responseCode = "403", description = "Access denied - treatment belongs to another user"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetRemindersByTreatment {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Update reminder status",
			description = "Updates the status of a reminder (TAKEN, MISSED, SNOOZED, DISMISSED, etc.) with automatic timestamp updates. "
					+ "**Status Flow:** SCHEDULED → ACTIVE → TAKEN/MISSED/SNOOZED/DISMISSED. "
					+ "Used to track medication adherence and user interactions with reminders.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Reminder status updated successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.ReminderResponse.class))),
			@ApiResponse(responseCode = "404", description = "Reminder not found"),
			@ApiResponse(responseCode = "403", description = "Access denied - reminder belongs to another user"),
			@ApiResponse(responseCode = "400", description = "Invalid status transition"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface UpdateReminderStatus {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get reminders by status",
			description = "Retrieves user's reminders filtered by status with full date-time information. "
					+ "**Use Cases:** " + "• TAKEN reminders for adherence tracking "
					+ "• MISSED reminders for follow-up " + "• SCHEDULED reminders for upcoming notifications "
					+ "• SNOOZED reminders for re-activation")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Reminders retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.ReminderResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetRemindersByStatus {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Delete reminder",
			description = "Deletes a specific reminder permanently. User must own the reminder through the associated treatment. "
					+ "**Warning:** This action cannot be undone. Consider updating status to DISMISSED instead for audit trail.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Reminder deleted successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
			@ApiResponse(responseCode = "404", description = "Reminder not found"),
			@ApiResponse(responseCode = "403", description = "Access denied - reminder belongs to another user"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface DeleteReminder {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get reminders with medication details",
			description = "Retrieves all reminders for the authenticated user with their associated medication and prescription details. "
					+ "Returns a flat list of reminders, each containing full medication and prescription information.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Reminders with medication details retrieved successfully",
					content = @Content(mediaType = "application/json", schema = @Schema(
							implementation = com.idvey.afya.payload.response.ReminderWithMedicationResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetRemindersWithMedications {

	}

}