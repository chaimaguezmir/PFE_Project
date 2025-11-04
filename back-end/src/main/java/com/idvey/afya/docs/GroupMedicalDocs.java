package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.lang.annotation.*;

@Tag(name = "Group Medical Management",
		description = "Medical data management for group members by Managers and Responsibles - Access and manage prescriptions, treatments, and reminders for other group members")
public final class GroupMedicalDocs {

	private GroupMedicalDocs() {
	} // no instantiation

	// ============== PRESCRIPTION ENDPOINTS ==============

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get user's prescriptions",
			description = "Retrieve all prescriptions for a specific group member. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Prescriptions retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PrescriptionResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "User or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetUserPrescriptions {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Create prescription for user",
			description = "Create a new prescription for a specific group member. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "201", description = "Prescription created successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PrescriptionResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data or validation failed"),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "User, group, or disease not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface CreatePrescriptionForUser {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Update user's prescription",
			description = "Update an existing prescription for a group member. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Prescription updated successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PrescriptionResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data or validation failed"),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "Prescription, user, or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface UpdateUserPrescription {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Delete user's prescription",
			description = "Delete a prescription for a group member. Only accessible by MANAGERS in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Prescription deleted successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - only MANAGERS can delete prescriptions"),
			@ApiResponse(responseCode = "404", description = "Prescription, user, or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface DeleteUserPrescription {

	}

	// ============== TREATMENT ENDPOINTS ==============

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get user's treatments",
			description = "Retrieve all treatments for a specific group member across all prescriptions. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Treatments retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.TreatmentResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "User or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetUserTreatments {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get treatments by prescription",
			description = "Retrieve treatments for a specific prescription of a group member. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Treatments retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.TreatmentResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "Prescription, user, or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetTreatmentsByPrescription {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Create treatment for user",
			description = "Create a new treatment for a group member's prescription. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "201", description = "Treatment created successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.TreatmentResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data or validation failed"),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "User, group, prescription, or medicine not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface CreateTreatmentForUser {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Update user's treatment",
			description = "Update an existing treatment for a group member. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Treatment updated successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.TreatmentResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data or validation failed"),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "Treatment, user, or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface UpdateUserTreatment {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Delete user's treatment",
			description = "Delete a treatment for a group member. Only accessible by MANAGERS in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Treatment deleted successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - only MANAGERS can delete treatments"),
			@ApiResponse(responseCode = "404", description = "Treatment, user, or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface DeleteUserTreatment {

	}

	// ============== REMINDER ENDPOINTS ==============

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get user's reminders with medications",
			description = "Retrieve all reminders for a group member with full medication and prescription details. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Reminders with medication details retrieved successfully",
					content = @Content(mediaType = "application/json", schema = @Schema(
							implementation = com.idvey.afya.payload.response.ReminderWithMedicationResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "User or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetUserRemindersWithMedications {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get user's reminders",
			description = "Retrieve all reminders for a specific group member. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Reminders retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.ReminderResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "User or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetUserReminders {

	}

	// ============== GROUP OVERVIEW ENDPOINTS ==============

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get group medical overview",
			description = "Get a comprehensive medical overview of all group members including prescription counts, treatment counts, and recent activity. Only accessible by MANAGERS and RESPONSIBLES.")
	@ApiResponses({ @ApiResponse(responseCode = "200", description = "Group medical overview retrieved successfully",
			content = @Content(mediaType = "application/json", schema = @Schema(
					implementation = com.idvey.afya.payload.response.GroupMemberMedicalOverviewResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "Group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetGroupMedicalOverview {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get user medical summary",
			description = "Get a detailed medical summary for a specific group member including user info, prescription summary, treatment summary, and reminder statistics. Only accessible by MANAGERS and RESPONSIBLES in the same group.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "User medical summary retrieved successfully",
					content = @Content(mediaType = "application/json", schema = @Schema(
							implementation = com.idvey.afya.payload.response.UserMedicalSummaryResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - insufficient group permissions"),
			@ApiResponse(responseCode = "404", description = "User or group not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetUserMedicalSummary {

	}

}