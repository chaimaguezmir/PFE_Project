package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.lang.annotation.*;

@Tag(name = "Prescriptions", description = "Prescription management with automatic date calculation")
public final class PrescriptionDocs {

	private PrescriptionDocs() {
	} // no instantiation

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Create new prescription",
			description = "Creates a new prescription with automatic start date (current date) and selected diseases. End date will be calculated automatically when treatments are added.")
	@ApiResponses({
			@ApiResponse(responseCode = "201", description = "Prescription created successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PrescriptionResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data or validation failed"),
			@ApiResponse(responseCode = "404", description = "One or more diseases not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface CreatePrescription {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get user's prescriptions",
			description = "Retrieves all prescriptions belonging to the authenticated user, ordered by creation date (newest first)")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Prescriptions retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PrescriptionResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetUserPrescriptions {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get active prescriptions",
			description = "Retrieves all active (non-expired) prescriptions for the authenticated user. A prescription is active if its end date is null or in the future.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Active prescriptions retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PrescriptionResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetActivePrescriptions {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get prescription details",
			description = "Retrieves detailed information about a specific prescription including all treatments, diseases, and medicine details")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Prescription details retrieved successfully",
					content = @Content(mediaType = "application/json", schema = @Schema(
							implementation = com.idvey.afya.payload.response.PrescriptionDetailResponse.class))),
			@ApiResponse(responseCode = "404", description = "Prescription not found"),
			@ApiResponse(responseCode = "403", description = "Access denied - prescription belongs to another user"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetPrescriptionDetail {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Update prescription",
			description = "Updates prescription name and associated diseases. Note: End date is automatically managed based on treatments and cannot be modified directly.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Prescription updated successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PrescriptionResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data or validation failed"),
			@ApiResponse(responseCode = "404", description = "Prescription or disease not found"),
			@ApiResponse(responseCode = "403", description = "Access denied - prescription belongs to another user"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface UpdatePrescription {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Delete prescription",
			description = "Deletes a prescription and all its associated treatments. This action cannot be undone.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Prescription deleted successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
			@ApiResponse(responseCode = "404", description = "Prescription not found"),
			@ApiResponse(responseCode = "403", description = "Access denied - prescription belongs to another user"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface DeletePrescription {

	}

}