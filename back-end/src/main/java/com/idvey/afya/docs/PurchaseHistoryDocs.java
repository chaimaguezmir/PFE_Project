package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import java.lang.annotation.*;

@Tag(name = "Purchase History", description = "Medicine purchase and consumption tracking")
public final class PurchaseHistoryDocs {

	private PurchaseHistoryDocs() {
	} // no instantiation

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Add purchase record", description = "Records a new medicine purchase or consumption")
	@ApiResponses({
			@ApiResponse(responseCode = "201", description = "Purchase recorded successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PurchaseHistoryResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data"),
			@ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
			@ApiResponse(responseCode = "404", description = "Medicine not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface AddPurchase {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get purchase history", description = "Retrieves purchase history for a specific medicine")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Purchase history retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PurchaseHistoryResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
			@ApiResponse(responseCode = "404", description = "Medicine not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetPurchaseHistory {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Update purchase record", description = "Updates an existing purchase record")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Purchase updated successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PurchaseHistoryResponse.class))),
			@ApiResponse(responseCode = "400", description = "Invalid input data"),
			@ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
			@ApiResponse(responseCode = "404", description = "Purchase record not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface UpdatePurchase {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Delete purchase record", description = "Deletes a purchase record")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Purchase deleted successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
			@ApiResponse(responseCode = "404", description = "Purchase record not found"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface DeletePurchase {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get expired purchases", description = "Retrieves all expired medicine purchases")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Expired purchases retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PurchaseHistoryResponse.class))),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetExpiredPurchases {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Get purchases by date range",
			description = "Retrieves purchases within a specific date range")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Purchases retrieved successfully",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.PurchaseHistoryResponse.class))),
			@ApiResponse(responseCode = "403", description = "Access denied - not a member of the group"),
			@ApiResponse(responseCode = "401", description = "Unauthorized") })
	public @interface GetPurchasesByDateRange {

	}

}