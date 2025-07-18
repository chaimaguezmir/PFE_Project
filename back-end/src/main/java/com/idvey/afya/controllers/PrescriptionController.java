package com.idvey.afya.controllers;

import com.idvey.afya.docs.PrescriptionDocs;
import com.idvey.afya.payload.request.CreatePrescriptionRequest;
import com.idvey.afya.payload.request.UpdatePrescriptionRequest;
import com.idvey.afya.payload.response.MessageResponse;
import com.idvey.afya.payload.response.PrescriptionDetailResponse;
import com.idvey.afya.payload.response.PrescriptionResponse;
import com.idvey.afya.security.service.PrescriptionService;
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
@RequestMapping("/api/prescriptions")
@RequiredArgsConstructor
@Tag(name = "Prescriptions")
public class PrescriptionController {

    private final PrescriptionService prescriptionService;

    @PrescriptionDocs.CreatePrescription
    @PostMapping
    public ResponseEntity<PrescriptionResponse> createPrescription(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @Valid @RequestBody CreatePrescriptionRequest request) {
        PrescriptionResponse response = prescriptionService.createPrescription(currentUser.getId(), request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PrescriptionDocs.GetUserPrescriptions
    @GetMapping
    public ResponseEntity<List<PrescriptionResponse>> getUserPrescriptions(
            @AuthenticationPrincipal UserDetailsImpl currentUser) {
        List<PrescriptionResponse> prescriptions = prescriptionService.getUserPrescriptions(currentUser.getId());
        return ResponseEntity.ok(prescriptions);
    }

    @PrescriptionDocs.GetActivePrescriptions
    @GetMapping("/active")
    public ResponseEntity<List<PrescriptionResponse>> getActivePrescriptions(
            @AuthenticationPrincipal UserDetailsImpl currentUser) {
        List<PrescriptionResponse> prescriptions = prescriptionService.getActivePrescriptions(currentUser.getId());
        return ResponseEntity.ok(prescriptions);
    }

    @PrescriptionDocs.GetPrescriptionDetail
    @GetMapping("/{id}")
    public ResponseEntity<PrescriptionDetailResponse> getPrescriptionDetail(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID id) {
        PrescriptionDetailResponse response = prescriptionService.getPrescriptionDetail(currentUser.getId(), id);
        return ResponseEntity.ok(response);
    }

    @PrescriptionDocs.UpdatePrescription
    @PutMapping("/{id}")
    public ResponseEntity<PrescriptionResponse> updatePrescription(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID id,
            @Valid @RequestBody UpdatePrescriptionRequest request) {
        PrescriptionResponse response = prescriptionService.updatePrescription(currentUser.getId(), id, request);
        return ResponseEntity.ok(response);
    }

    @PrescriptionDocs.DeletePrescription
    @DeleteMapping("/{id}")
    public ResponseEntity<MessageResponse> deletePrescription(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID id) {
        prescriptionService.deletePrescription(currentUser.getId(), id);
        return ResponseEntity.ok(new MessageResponse("Prescription deleted successfully"));
    }
}
