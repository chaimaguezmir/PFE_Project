package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.lang.annotation.*;

@Tag(name = "Diseases", description = "Disease management - Global disease catalog for prescription association")
public final class DiseaseDocs {

	private DiseaseDocs() {
	} // no instantiation

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Create new disease",
			description = "Creates a new disease in the global disease catalog. Disease names must be unique across the system.")
	@ApiResponses({
			@ApiResponse(responseCode = "201", description = "Disease created successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.DiseaseResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data or disease name already exists"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface CreateDisease {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get all diseases",
			description = "Retrieves all diseases from the global catalog, ordered alphabetically by name")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Diseases retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.DiseaseResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetAllDiseases {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Search diseases",
			description = "Searches diseases by name using case-insensitive partial matching")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Search completed successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.DiseaseResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface SearchDiseases {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get disease by ID", description = "Retrieves a specific disease by its unique identifier")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Disease found successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.DiseaseResponse.class))),
			@ApiResponse(responseCode = "404", description = "Disease not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetDiseaseById {

	}

}