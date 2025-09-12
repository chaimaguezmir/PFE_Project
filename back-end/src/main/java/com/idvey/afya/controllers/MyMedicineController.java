package com.idvey.afya.controllers;

import com.idvey.afya.docs.MyMedicineDocs;
import com.idvey.afya.payload.request.CreateMyMedicineRequest;
import com.idvey.afya.payload.request.UpdateMyMedicineRequest;
import com.idvey.afya.payload.response.*;
import com.idvey.afya.security.service.MyMedicineService;
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
@RequestMapping("/api/my-medicines")
@RequiredArgsConstructor
@Tag(name = "My Medicines")
public class MyMedicineController {

	private final MyMedicineService myMedicineService;

	@MyMedicineDocs.AddMedicine
	@PostMapping
	public ResponseEntity<MyMedicineResponse> createMyMedicine(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@Valid @RequestBody CreateMyMedicineRequest request) throws AccessDeniedException {
		MyMedicineResponse response = myMedicineService.createMyMedicine(currentUser.getId(), request);
		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}

	@MyMedicineDocs.GetMedicinesByPharmacyBox
	@GetMapping("/pharmacy-box/{pharmacyBoxId}")
	public ResponseEntity<List<MyMedicineResponse>> getMyMedicinesByPharmacyBox(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID pharmacyBoxId)
			throws AccessDeniedException {
		List<MyMedicineResponse> medicines = myMedicineService.getMyMedicinesByPharmacyBox(currentUser.getId(),
				pharmacyBoxId);
		return ResponseEntity.ok(medicines);
	}

	@MyMedicineDocs.GetMedicinesByPharmacyBox
	@GetMapping("/pharmacy-box/{pharmacyBoxId}/ordered")
	public ResponseEntity<List<MyMedicineResponse>> getMyMedicinesByPharmacyBoxOrdered(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID pharmacyBoxId)
			throws AccessDeniedException {
		List<MyMedicineResponse> medicines = myMedicineService.getMyMedicinesByPharmacyBoxOrdered(currentUser.getId(),
				pharmacyBoxId);
		return ResponseEntity.ok(medicines);
	}

	@MyMedicineDocs.SearchInPharmacyBox
	@GetMapping("/pharmacy-box/{pharmacyBoxId}/search")
	public ResponseEntity<List<MyMedicineResponse>> searchMyMedicinesInPharmacyBox(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID pharmacyBoxId,
			@RequestParam String name) throws AccessDeniedException {
		List<MyMedicineResponse> medicines = myMedicineService.searchMyMedicinesInPharmacyBox(currentUser.getId(),
				pharmacyBoxId, name);
		return ResponseEntity.ok(medicines);
	}

	@MyMedicineDocs.SearchInPharmacyBox
	@GetMapping("/pharmacy-box/{pharmacyBoxId}/form/{form}")
	public ResponseEntity<List<MyMedicineResponse>> findByPharmacyBoxAndForm(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID pharmacyBoxId,
			@PathVariable String form) throws AccessDeniedException {
		List<MyMedicineResponse> medicines = myMedicineService.findByPharmacyBoxAndForm(currentUser.getId(),
				pharmacyBoxId, form);
		return ResponseEntity.ok(medicines);
	}

	@MyMedicineDocs.GetMedicinesByPharmacyBox
	@GetMapping("/medicine/{medicineId}")
	public ResponseEntity<List<MyMedicineResponse>> findByMedicineId(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID medicineId) {
		List<MyMedicineResponse> medicines = myMedicineService.findByMedicineId(medicineId);
		return ResponseEntity.ok(medicines);
	}

	@MyMedicineDocs.GetMedicinesByPharmacyBox
	@GetMapping("/pharmacy-box/{pharmacyBoxId}/count")
	public ResponseEntity<Long> countMedicinesInPharmacyBox(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID pharmacyBoxId) throws AccessDeniedException {
		long count = myMedicineService.countMedicinesInPharmacyBox(currentUser.getId(), pharmacyBoxId);
		return ResponseEntity.ok(count);
	}

	@MyMedicineDocs.GetMedicinesByPharmacyBox
	@GetMapping("/pharmacy-box/{pharmacyBoxId}/medicine/{medicineId}/exists")
	public ResponseEntity<Boolean> checkIfMedicineExistsInPharmacyBox(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID pharmacyBoxId,
			@PathVariable UUID medicineId) throws AccessDeniedException {
		boolean exists = myMedicineService.existsInPharmacyBox(currentUser.getId(), pharmacyBoxId, medicineId);
		return ResponseEntity.ok(exists);
	}

	@MyMedicineDocs.GetMedicineDetail
	@GetMapping("/{id}")
	public ResponseEntity<MyMedicineDetailResponse> getMyMedicineDetail(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID id) throws AccessDeniedException {
		MyMedicineDetailResponse medicine = myMedicineService.getMyMedicineDetail(currentUser.getId(), id);
		return ResponseEntity.ok(medicine);
	}

	@MyMedicineDocs.UpdateMedicine
	@PutMapping("/{id}")
	public ResponseEntity<MyMedicineResponse> updateMyMedicine(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID id, @Valid @RequestBody UpdateMyMedicineRequest request) throws AccessDeniedException {
		MyMedicineResponse response = myMedicineService.updateMyMedicine(currentUser.getId(), id, request);
		return ResponseEntity.ok(response);
	}

	@MyMedicineDocs.DeleteMedicine
	@DeleteMapping("/{id}")
	public ResponseEntity<MessageResponse> deleteMyMedicine(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID id) throws AccessDeniedException {
		myMedicineService.deleteMyMedicine(currentUser.getId(), id);
		return ResponseEntity.ok(new MessageResponse("Medicine deleted successfully"));
	}

	@MyMedicineDocs.GetPharmacyBoxOverview
	@GetMapping("/pharmacy-box/{pharmacyBoxId}/overview")
	public ResponseEntity<PharmacyBoxMedicinesResponse> getPharmacyBoxMedicines(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID pharmacyBoxId)
			throws AccessDeniedException {
		PharmacyBoxMedicinesResponse response = myMedicineService.getPharmacyBoxMedicines(currentUser.getId(),
				pharmacyBoxId);
		return ResponseEntity.ok(response);
	}

	@MyMedicineDocs.GetMedicineDetail
	@GetMapping("/pharmacy-box/{pharmacyBoxId}/medicine/{medicineId}")
	public ResponseEntity<MyMedicineResponse> getMyMedicineByMedicineIdAndPharmacyBox(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID pharmacyBoxId,
			@PathVariable UUID medicineId) throws AccessDeniedException {
		MyMedicineResponse response = myMedicineService.getMyMedicineByMedicineIdAndPharmacyBox(currentUser.getId(),
				pharmacyBoxId, medicineId);
		return ResponseEntity.ok(response);
	}

}