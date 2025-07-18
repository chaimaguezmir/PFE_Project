package com.idvey.afya.controllers;

import com.idvey.afya.docs.DiseaseDocs;
import com.idvey.afya.payload.request.CreateDiseaseRequest;
import com.idvey.afya.payload.response.DiseaseResponse;
import com.idvey.afya.security.service.DiseaseService;
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
@RequestMapping("/api/diseases")
@RequiredArgsConstructor
@Tag(name = "Diseases")
public class DiseaseController {

    private final DiseaseService diseaseService;

    @DiseaseDocs.CreateDisease
    @PostMapping
    public ResponseEntity<DiseaseResponse> createDisease(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @Valid @RequestBody CreateDiseaseRequest request) {
        DiseaseResponse response = diseaseService.createDisease(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @DiseaseDocs.GetAllDiseases
    @GetMapping
    public ResponseEntity<List<DiseaseResponse>> getAllDiseases(
            @AuthenticationPrincipal UserDetailsImpl currentUser) {
        List<DiseaseResponse> diseases = diseaseService.getAllDiseases();
        return ResponseEntity.ok(diseases);
    }

    @DiseaseDocs.SearchDiseases
    @GetMapping("/search")
    public ResponseEntity<List<DiseaseResponse>> searchDiseases(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @RequestParam String name) {
        List<DiseaseResponse> diseases = diseaseService.searchDiseases(name);
        return ResponseEntity.ok(diseases);
    }

    @DiseaseDocs.GetDiseaseById
    @GetMapping("/{id}")
    public ResponseEntity<DiseaseResponse> getDiseaseById(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID id) {
        DiseaseResponse disease = diseaseService.getDiseaseById(id);
        return ResponseEntity.ok(disease);
    }
}