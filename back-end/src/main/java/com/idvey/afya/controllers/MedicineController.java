package com.idvey.afya.controllers;

import com.idvey.afya.docs.MedicineDocs;
import com.idvey.afya.payload.request.CreateMedicineRequest;
import com.idvey.afya.payload.response.MedicineResponse;
import com.idvey.afya.security.service.MedicineService;
import com.idvey.afya.security.service.UserDetailsImpl;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/medicines")
@RequiredArgsConstructor
@Tag(name = "Medicine")
public class MedicineController {

	private final MedicineService medicineService;

	@MedicineDocs.CreateMedicine
	@PostMapping
	public ResponseEntity<MedicineResponse> createMedicine(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@Valid @RequestBody CreateMedicineRequest request) {
		MedicineResponse response = medicineService.createMedicine(request);
		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}

	@MedicineDocs.GetAllMedicines
	@GetMapping
	public ResponseEntity<List<MedicineResponse>> getAllMedicines(
			@AuthenticationPrincipal UserDetailsImpl currentUser) {
		List<MedicineResponse> medicines = medicineService.getAllMedicines();
		return ResponseEntity.ok(medicines);
	}

	@MedicineDocs.GetMedicineById
	@GetMapping("/{id}")
	public ResponseEntity<MedicineResponse> getMedicineById(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID id) {
		MedicineResponse medicine = medicineService.getMedicineById(id);
		return ResponseEntity.ok(medicine);
	}

	@MedicineDocs.SearchMedicines
	@GetMapping("/search")
	public ResponseEntity<List<MedicineResponse>> searchMedicines(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@RequestParam String q) {
		List<MedicineResponse> medicines = medicineService.searchMedicines(q);
		return ResponseEntity.ok(medicines);
	}

	@MedicineDocs.SearchMedicines
	@GetMapping("/search/name")
	public ResponseEntity<List<MedicineResponse>> searchByName(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@RequestParam String name) {
		List<MedicineResponse> medicines = medicineService.findByNameContaining(name);
		return ResponseEntity.ok(medicines);
	}

	@MedicineDocs.SearchMedicines
	@GetMapping("/search/manufacturer")
	public ResponseEntity<List<MedicineResponse>> searchByManufacturer(
			@AuthenticationPrincipal UserDetailsImpl currentUser, @RequestParam String manufacturer) {
		List<MedicineResponse> medicines = medicineService.findByManufacturer(manufacturer);
		return ResponseEntity.ok(medicines);
	}

	@MedicineDocs.SearchMedicines
	@GetMapping("/dosage-form/{dosageForm}")
	public ResponseEntity<List<MedicineResponse>> findByDosageForm(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable String dosageForm) {
		List<MedicineResponse> medicines = medicineService.findByDosageForm(dosageForm);
		return ResponseEntity.ok(medicines);
	}

	@MedicineDocs.GetMedicineById
	@GetMapping("/name/{name}")
	public ResponseEntity<MedicineResponse> findByExactName(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable String name) {
		MedicineResponse medicine = medicineService.findByName(name);
		return ResponseEntity.ok(medicine);
	}

	@MedicineDocs.FindByBarcode
	@GetMapping("/barcode/{barcode}")
	public ResponseEntity<MedicineResponse> findByBarcode(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable String barcode) {
		MedicineResponse medicine = medicineService.findByBarcode(barcode);
		return ResponseEntity.ok(medicine);
	}

	@MedicineDocs.FilterByPrescription
	@GetMapping("/prescription")
	public ResponseEntity<List<MedicineResponse>> findByPrescriptionRequirement(
			@AuthenticationPrincipal UserDetailsImpl currentUser,
			@RequestParam(defaultValue = "true") boolean requiresPrescription) {
		List<MedicineResponse> medicines = medicineService.findByRequiresPrescription(requiresPrescription);
		return ResponseEntity.ok(medicines);
	}

}