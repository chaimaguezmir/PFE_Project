package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.lang.annotation.*;

@Tag(name = "Treatments", description = "Treatment management with automatic prescription end date calculation")
public final class TreatmentDocs {

    private TreatmentDocs() {} // no instantiation

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Create new treatment",
            description = "Creates a new treatment for a prescription using a specific medicine. The treatment start date is set to creation time, and the prescription end date is automatically updated to reflect the latest treatment end date.")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Treatment created successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.TreatmentResponse.class))),
            @ApiResponse(responseCode = "400", description = "Invalid input data or validation failed"),
            @ApiResponse(responseCode = "404", description = "Prescription or MyMedicine not found"),
            @ApiResponse(responseCode = "403", description = "Access denied - prescription belongs to another user"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface CreateTreatment {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get treatments by prescription",
            description = "Retrieves all treatments associated with a specific prescription, ordered by creation date (newest first)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Treatments retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.TreatmentResponse.class))),
            @ApiResponse(responseCode = "404", description = "Prescription not found"),
            @ApiResponse(responseCode = "403", description = "Access denied - prescription belongs to another user"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetTreatmentsByPrescription {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Update treatment",
            description = "Updates treatment details (dosage, frequency, duration). The prescription end date is automatically recalculated based on all treatments.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Treatment updated successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.TreatmentResponse.class))),
            @ApiResponse(responseCode = "400", description = "Invalid input data or validation failed"),
            @ApiResponse(responseCode = "404", description = "Treatment not found"),
            @ApiResponse(responseCode = "403", description = "Access denied - treatment belongs to another user"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface UpdateTreatment {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get all user treatments",
            description = "Retrieves all treatments across all prescriptions for the authenticated user, ordered by creation date (newest first)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "All user treatments retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.TreatmentResponse.class))),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetAllUserTreatments {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Delete treatment",
            description = "Deletes a treatment and automatically recalculates the prescription end date. If this was the last treatment, the prescription end date is set to null.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Treatment deleted successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
            @ApiResponse(responseCode = "404", description = "Treatment not found"),
            @ApiResponse(responseCode = "403", description = "Access denied - treatment belongs to another user"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface DeleteTreatment {}
}