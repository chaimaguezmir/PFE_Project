package com.idvey.afya.controllers;

import com.idvey.afya.payload.request.PrescriptionRequest;
import com.idvey.afya.payload.response.PrescriptionResponse;
import com.idvey.afya.security.service.PrescriptionService;
import com.idvey.afya.security.service.UserDetailsImpl;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/prescriptions")
@RequiredArgsConstructor
public class PrescriptionController {

    private final PrescriptionService prescriptionService;

    @PostMapping
    public ResponseEntity<PrescriptionResponse> create(@AuthenticationPrincipal UserDetailsImpl user,
                                                       @Valid @RequestBody PrescriptionRequest request) {
        return ResponseEntity.ok(prescriptionService.create(user.getId(), request));
    }

    @GetMapping
    public ResponseEntity<List<PrescriptionResponse>> getAll(@AuthenticationPrincipal UserDetailsImpl user) {
        return ResponseEntity.ok(prescriptionService.getAllForUser(user.getId()));
    }

//    @DeleteMapping("/{id}")
//    public ResponseEntity<Void> delete(@AuthenticationPrincipal UserDetailsImpl user,
//                                       @PathVariable UUID id) {
//        prescriptionService.delete(id, user.getId());
//        return ResponseEntity.noContent().build();
//    }
}
