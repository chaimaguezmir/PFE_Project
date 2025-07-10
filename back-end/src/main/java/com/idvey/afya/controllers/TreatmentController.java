package com.idvey.afya.controllers;


import com.idvey.afya.payload.request.TreatmentRequest;
import com.idvey.afya.payload.response.TreatmentResponse;
import com.idvey.afya.security.service.TreatmentService;
import com.idvey.afya.security.service.UserDetailsImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/treatments")
@RequiredArgsConstructor
public class TreatmentController {

    private final TreatmentService treatmentService;

    @PostMapping
    public ResponseEntity<TreatmentResponse> create(@AuthenticationPrincipal UserDetailsImpl currentUser,
                                                    @RequestBody TreatmentRequest request) {
        return ResponseEntity.ok(treatmentService.create(currentUser.getId(), request));
    }

    @GetMapping
    public ResponseEntity<List<TreatmentResponse>> getAll(@AuthenticationPrincipal UserDetailsImpl currentUser) {
        return ResponseEntity.ok(treatmentService.getAll(currentUser.getId()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@AuthenticationPrincipal UserDetailsImpl currentUser,
                                       @PathVariable UUID id) {
        treatmentService.delete(id, currentUser.getId());
        return ResponseEntity.noContent().build();
    }
    @PutMapping("/{id}")
    public ResponseEntity<TreatmentResponse> update(@AuthenticationPrincipal UserDetailsImpl currentUser,
                                                    @PathVariable UUID id,
                                                    @RequestBody TreatmentRequest request) {
        return ResponseEntity.ok(treatmentService.update(id, currentUser.getId(), request));
    }
}