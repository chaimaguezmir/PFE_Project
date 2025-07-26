package com.idvey.afya.controllers;

import com.idvey.afya.docs.PurchaseHistoryDocs;
import com.idvey.afya.payload.request.AddPurchaseHistoryRequest;
import com.idvey.afya.payload.request.UpdatePurchaseHistoryRequest;
import com.idvey.afya.payload.response.MessageResponse;
import com.idvey.afya.payload.response.PurchaseHistoryResponse;
import com.idvey.afya.security.service.PurchaseHistoryService;
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
@RequestMapping("/api/purchase-history")
@RequiredArgsConstructor
@Tag(name = "Purchase History")
public class PurchaseHistoryController {

	private final PurchaseHistoryService purchaseHistoryService;

	@PurchaseHistoryDocs.AddPurchase
	@PostMapping
	public ResponseEntity<PurchaseHistoryResponse> addPurchaseHistory(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @Valid @RequestBody AddPurchaseHistoryRequest request)
			throws AccessDeniedException {
		PurchaseHistoryResponse response = purchaseHistoryService.addPurchaseHistory(currentUser.getId(), request);
		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}

	@PurchaseHistoryDocs.GetPurchaseHistory
	@GetMapping("/my-medicine/{myMedicineId}")
	public ResponseEntity<List<PurchaseHistoryResponse>> getPurchaseHistoryByMyMedicine(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID myMedicineId)
			throws AccessDeniedException {
		List<PurchaseHistoryResponse> history = purchaseHistoryService
			.getPurchaseHistoryByMyMedicine(currentUser.getId(), myMedicineId);
		return ResponseEntity.ok(history);
	}

	@PurchaseHistoryDocs.GetPurchaseHistory
	@GetMapping("/my-medicine/{myMedicineId}/basic")
	public ResponseEntity<List<PurchaseHistoryResponse>> getPurchaseHistoryByMyMedicineBasic(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID myMedicineId)
			throws AccessDeniedException {
		List<PurchaseHistoryResponse> history = purchaseHistoryService
			.getPurchaseHistoryByMyMedicineBasic(currentUser.getId(), myMedicineId);
		return ResponseEntity.ok(history);
	}

	@PurchaseHistoryDocs.GetPurchasesByDateRange
	@GetMapping("/my-medicine/{myMedicineId}/date-range")
	public ResponseEntity<List<PurchaseHistoryResponse>> getPurchaseHistoryByDateRange(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID myMedicineId,
			@RequestParam String startDate, @RequestParam String endDate) throws AccessDeniedException {
		java.time.LocalDateTime start = java.time.LocalDateTime.parse(startDate);
		java.time.LocalDateTime end = java.time.LocalDateTime.parse(endDate);
		List<PurchaseHistoryResponse> history = purchaseHistoryService
			.getPurchaseHistoryByDateRange(currentUser.getId(), myMedicineId, start, end);
		return ResponseEntity.ok(history);
	}

	@PurchaseHistoryDocs.GetExpiredPurchases
	@GetMapping("/expired")
	public ResponseEntity<List<PurchaseHistoryResponse>> getExpiredPurchases(
			@AuthenticationPrincipal UserDetailsImpl currentUser) {
		List<PurchaseHistoryResponse> history = purchaseHistoryService.getExpiredPurchases();
		return ResponseEntity.ok(history);
	}

	@PurchaseHistoryDocs.GetExpiredPurchases
	@GetMapping("/expiring-between")
	public ResponseEntity<List<PurchaseHistoryResponse>> getPurchasesExpiringBetween(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @RequestParam String startDate,
			@RequestParam String endDate) {
		java.time.LocalDate start = java.time.LocalDate.parse(startDate);
		java.time.LocalDate end = java.time.LocalDate.parse(endDate);
		List<PurchaseHistoryResponse> history = purchaseHistoryService.getPurchasesExpiringBetween(start, end);
		return ResponseEntity.ok(history);
	}

	@PurchaseHistoryDocs.GetPurchaseHistory
	@GetMapping("/my-medicine/{myMedicineId}/total-quantity")
	public ResponseEntity<Long> getTotalQuantityPurchased(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID myMedicineId) {
		Long totalQuantity = purchaseHistoryService.getTotalQuantityPurchased(myMedicineId);
		return ResponseEntity.ok(totalQuantity != null ? totalQuantity : 0L);
	}

	@PurchaseHistoryDocs.GetPurchaseHistory
	@GetMapping("/my-medicine/{myMedicineId}/count")
	public ResponseEntity<Long> getPurchaseHistoryCount(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID myMedicineId) {
		long count = purchaseHistoryService.getPurchaseHistoryCount(myMedicineId);
		return ResponseEntity.ok(count);
	}

	@PurchaseHistoryDocs.GetPurchaseHistory
	@GetMapping("/pharmacy-box/{pharmacyBoxId}")
	public ResponseEntity<List<PurchaseHistoryResponse>> getPurchaseHistoryByPharmacyBox(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID pharmacyBoxId)
			throws AccessDeniedException {
		List<PurchaseHistoryResponse> history = purchaseHistoryService
			.getPurchaseHistoryByPharmacyBox(currentUser.getId(), pharmacyBoxId);
		return ResponseEntity.ok(history);
	}

	@PurchaseHistoryDocs.UpdatePurchase
	@PutMapping("/{id}")
	public ResponseEntity<PurchaseHistoryResponse> updatePurchaseHistory(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID id,
			@Valid @RequestBody UpdatePurchaseHistoryRequest request) throws AccessDeniedException {
		PurchaseHistoryResponse response = purchaseHistoryService.updatePurchaseHistory(currentUser.getId(), id,
				request);
		return ResponseEntity.ok(response);
	}

	@PurchaseHistoryDocs.DeletePurchase
	@DeleteMapping("/{id}")
	public ResponseEntity<MessageResponse> deletePurchaseHistory(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID id) throws AccessDeniedException {
		purchaseHistoryService.deletePurchaseHistory(currentUser.getId(), id);
		return ResponseEntity.ok(new MessageResponse("Purchase history deleted successfully"));
	}

}