package com.idvey.afya.controllers;

import com.idvey.afya.docs.MedicineDocs;
import com.idvey.afya.payload.request.CreateMedicineRequest;
import com.idvey.afya.payload.request.UpdateMedicineBarcodeRequest;
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
    @GetMapping("/search/laboratory")
    public ResponseEntity<List<MedicineResponse>> searchByLaboratory(
            @AuthenticationPrincipal UserDetailsImpl currentUser, @RequestParam String laboratory) {
        List<MedicineResponse> medicines = medicineService.findByLaboratory(laboratory);
        return ResponseEntity.ok(medicines);
    }

    @MedicineDocs.SearchMedicines
    @GetMapping("/search/dci")
    public ResponseEntity<List<MedicineResponse>> searchByDci(@AuthenticationPrincipal UserDetailsImpl currentUser,
                                                              @RequestParam String dci) {
        List<MedicineResponse> medicines = medicineService.findByDci(dci);
        return ResponseEntity.ok(medicines);
    }

    @MedicineDocs.SearchMedicines
    @GetMapping("/search/therapeutic-class")
    public ResponseEntity<List<MedicineResponse>> searchByTherapeuticClass(
            @AuthenticationPrincipal UserDetailsImpl currentUser, @RequestParam String therapeuticClass) {
        List<MedicineResponse> medicines = medicineService.findByTherapeuticClass(therapeuticClass);
        return ResponseEntity.ok(medicines);
    }

    @MedicineDocs.SearchMedicines
    @GetMapping("/form/{form}")
    public ResponseEntity<List<MedicineResponse>> findByForm(@AuthenticationPrincipal UserDetailsImpl currentUser,
                                                             @PathVariable String form) {
        List<MedicineResponse> medicines = medicineService.findByForm(form);
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
    @GetMapping("/type/{medicationType}")
    public ResponseEntity<List<MedicineResponse>> findByMedicationType(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable String medicationType) {
        List<MedicineResponse> medicines = medicineService.findByMedicationType(medicationType);
        return ResponseEntity.ok(medicines);
    }

    @MedicineDocs.FilterByPrescription
    @GetMapping("/prescription-only")
    public ResponseEntity<List<MedicineResponse>> findPrescriptionMedicines(
            @AuthenticationPrincipal UserDetailsImpl currentUser) {
        List<MedicineResponse> medicines = medicineService.findPrescriptionMedicines();
        return ResponseEntity.ok(medicines);
    }

    @MedicineDocs.FilterByPrescription
    @GetMapping("/otc")
    public ResponseEntity<List<MedicineResponse>> findOTCMedicines(
            @AuthenticationPrincipal UserDetailsImpl currentUser) {
        List<MedicineResponse> medicines = medicineService.findOTCMedicines();
        return ResponseEntity.ok(medicines);
    }

    // Barcode management endpoints
    @MedicineDocs.UpdateMedicineBarcode
    @PutMapping("/{id}/barcode")
    public ResponseEntity<MedicineResponse> updateMedicineBarcode(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID id,
            @Valid @RequestBody UpdateMedicineBarcodeRequest request) {
        MedicineResponse response = medicineService.updateMedicineBarcode(id, request);
        return ResponseEntity.ok(response);
    }

    @MedicineDocs.RemoveMedicineBarcode
    @DeleteMapping("/{id}/barcode")
    public ResponseEntity<MedicineResponse> removeMedicineBarcode(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID id) {
        MedicineResponse response = medicineService.removeMedicineBarcode(id);
        return ResponseEntity.ok(response);
    }

}