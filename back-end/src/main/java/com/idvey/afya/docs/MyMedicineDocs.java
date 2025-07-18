package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import java.lang.annotation.*;

@Tag(name = "My Medicines", description = "Personal medicine management in pharmacy boxes")
public final class MyMedicineDocs {

    private MyMedicineDocs() {} // no instantiation

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Add medicine to pharmacy box", description = "Adds a medicine to user's pharmacy box")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Medicine added successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MyMedicineResponse.class))),
            @ApiResponse(responseCode = "400", description = "Medicine already exists in pharmacy box"),
            @ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
            @ApiResponse(responseCode = "404", description = "Pharmacy box or medicine not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface AddMedicine {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get medicines in pharmacy box", description = "Retrieves all medicines in a pharmacy box")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Medicines retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MyMedicineResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
            @ApiResponse(responseCode = "404", description = "Pharmacy box not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetMedicinesByPharmacyBox {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get medicine details", description = "Get detailed information about a medicine including purchase history")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Medicine details retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MyMedicineDetailResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
            @ApiResponse(responseCode = "404", description = "Medicine not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetMedicineDetail {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Update medicine", description = "Updates medicine name and form")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Medicine updated successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MyMedicineResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
            @ApiResponse(responseCode = "404", description = "Medicine not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface UpdateMedicine {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Delete medicine", description = "Removes a medicine from pharmacy box")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Medicine deleted successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
            @ApiResponse(responseCode = "404", description = "Medicine not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface DeleteMedicine {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Search medicines in pharmacy box", description = "Search medicines within a specific pharmacy box")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Search completed successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MyMedicineResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface SearchInPharmacyBox {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get pharmacy box overview", description = "Get complete overview of pharmacy box with all medicines")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Overview retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.PharmacyBoxMedicinesResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
            @ApiResponse(responseCode = "404", description = "Pharmacy box not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetPharmacyBoxOverview {}
}