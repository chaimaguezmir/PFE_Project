package com.idvey.afya.controllers;

import com.idvey.afya.docs.TreatmentDocs;
import com.idvey.afya.payload.request.CreateTreatmentRequest;
import com.idvey.afya.payload.request.UpdateTreatmentRequest;
import com.idvey.afya.payload.response.MessageResponse;
import com.idvey.afya.payload.response.TreatmentResponse;
import com.idvey.afya.security.service.TreatmentService;
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
@RequestMapping("/api/treatments")
@RequiredArgsConstructor
@Tag(name = "Treatments")
public class TreatmentController {

    private final TreatmentService treatmentService;

    @TreatmentDocs.CreateTreatment
    @PostMapping
    public ResponseEntity<TreatmentResponse> createTreatment(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @Valid @RequestBody CreateTreatmentRequest request) {
        TreatmentResponse response = treatmentService.createTreatment(currentUser.getId(), request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @TreatmentDocs.GetTreatmentsByPrescription
    @GetMapping("/prescription/{prescriptionId}")
    public ResponseEntity<List<TreatmentResponse>> getTreatmentsByPrescription(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID prescriptionId) {
        List<TreatmentResponse> treatments = treatmentService.getTreatmentsByPrescription(currentUser.getId(), prescriptionId);
        return ResponseEntity.ok(treatments);
    }

    @TreatmentDocs.UpdateTreatment
    @PutMapping("/{id}")
    public ResponseEntity<TreatmentResponse> updateTreatment(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID id,
            @Valid @RequestBody UpdateTreatmentRequest request) {
        TreatmentResponse response = treatmentService.updateTreatment(currentUser.getId(), id, request);
        return ResponseEntity.ok(response);
    }

    @TreatmentDocs.GetAllUserTreatments
    @GetMapping
    public ResponseEntity<List<TreatmentResponse>> getAllUserTreatments(
            @AuthenticationPrincipal UserDetailsImpl currentUser) {
        List<TreatmentResponse> treatments = treatmentService.getAllUserTreatments(currentUser.getId());
        return ResponseEntity.ok(treatments);
    }

    @TreatmentDocs.DeleteTreatment
    @DeleteMapping("/{id}")
    public ResponseEntity<MessageResponse> deleteTreatment(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID id) {
        treatmentService.deleteTreatment(currentUser.getId(), id);
        return ResponseEntity.ok(new MessageResponse("Treatment deleted successfully"));
    }
}
