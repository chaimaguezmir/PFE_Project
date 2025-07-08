package com.idvey.afya.controllers;

import com.idvey.afya.payload.request.MedicationRequest;
import com.idvey.afya.payload.response.MedicationResponse;
import com.idvey.afya.security.service.MedicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/medications")
@RequiredArgsConstructor
public class MedicationController {

    private final MedicationService medicationService;

    @PostMapping
    public ResponseEntity<MedicationResponse> create(@RequestBody MedicationRequest request) {
        return ResponseEntity.ok(medicationService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<MedicationResponse>> getAll() {
        return ResponseEntity.ok(medicationService.getAll());
    }

    @GetMapping("/search/{name}")
    public ResponseEntity<List<MedicationResponse>> searchByName(@PathVariable String name) {
        return ResponseEntity.ok(medicationService.searchByName(name));
    }

    @GetMapping("/barcode/{barcode}")
    public ResponseEntity<MedicationResponse> getByBarcode(@PathVariable String barcode) {
        return ResponseEntity.ok(medicationService.getByBarcode(barcode));
    }

    @PutMapping("/{id}")
    public ResponseEntity<MedicationResponse> update(@PathVariable UUID id,
                                                     @RequestBody MedicationRequest request) {
        return ResponseEntity.ok(medicationService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        medicationService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
