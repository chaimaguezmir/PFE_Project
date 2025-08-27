// MedicineDocs.java
package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.Parameter;

import java.lang.annotation.*;

@Tag(name = "Medicine", description = "Medicine master data management")
public final class MedicineDocs {

	private MedicineDocs() {
	} // no instantiation

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Create medicine", description = "Creates a new medicine in the master database")
	@ApiResponses({
			@ApiResponse(responseCode = "201", description = "Medicine created successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MedicineResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input or medicine already exists"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface CreateMedicine {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get all medicines", description = "Retrieves all medicines from the master database")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Medicines retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MedicineResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetAllMedicines {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get medicine by ID", description = "Retrieves a specific medicine by its ID")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Medicine found",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MedicineResponse.class))),
			@ApiResponse(responseCode = "404", description = "Medicine not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetMedicineById {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Search medicines", description = "Search medicines by name or manufacturer")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Search completed successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MedicineResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface SearchMedicines {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Find medicine by barcode", description = "Finds a medicine using its barcode")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Medicine found",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MedicineResponse.class))),
			@ApiResponse(responseCode = "404", description = "Medicine not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface FindByBarcode {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Filter by prescription requirement",
			description = "Get medicines by prescription requirement")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Medicines filtered successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MedicineResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface FilterByPrescription {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Update medicine barcode",
			description = "Updates the barcode of an existing medicine. The new barcode must be unique across the system.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Medicine barcode updated successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MedicineResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid barcode or barcode already exists"),
			@ApiResponse(responseCode = "404", description = "Medicine not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized")
	})
	public @interface UpdateMedicineBarcode {

	}


	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Remove medicine barcode",
			description = "Removes the barcode from an existing medicine by setting it to null. This allows the medicine to exist without a barcode.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Medicine barcode removed successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MedicineResponse.class))),
			@ApiResponse(responseCode = "404", description = "Medicine not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized")
	})
	public @interface RemoveMedicineBarcode {

	}

}