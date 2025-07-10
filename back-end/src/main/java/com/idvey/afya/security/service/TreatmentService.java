package com.idvey.afya.security.service;


import com.idvey.afya.models.Disease;
import com.idvey.afya.models.Treatment;
import com.idvey.afya.models.User;
import com.idvey.afya.payload.request.TreatmentRequest;
import com.idvey.afya.payload.response.TreatmentResponse;
import com.idvey.afya.repository.DiseaseRepository;
import com.idvey.afya.repository.TreatmentRepository;
import com.idvey.afya.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TreatmentService {

    private final TreatmentRepository treatmentRepository;
    private final UserRepository userRepository;
    private final DiseaseRepository diseaseRepository;


    @Transactional
    public TreatmentResponse create(UUID userId, TreatmentRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NoSuchElementException("User not found"));

        // Charger les maladies dans une nouvelle structure Set
        Set<Disease> diseases = request.getDiseaseIds().stream()
                .map(id -> diseaseRepository.findById(id)
                        .orElseThrow(() -> new NoSuchElementException("Disease not found: " + id)))
                .collect(Collectors.toSet());

        // Construire le traitement avec le Set déjà prêt
        Treatment treatment = Treatment.builder()
                .user(user)
                .name(request.getName())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .diseases(diseases)
                .build();

        // Sauvegarder et retourner la réponse
        return toResponse(treatmentRepository.save(treatment));
    }


    @Transactional
    public List<TreatmentResponse> getAll(UUID userId) {
        return treatmentRepository.findByUser_Id(userId).stream()
                .map(this::toResponse)
                .toList();
    }

    public void delete(UUID treatmentId, UUID userId) {
        Treatment treatment = treatmentRepository.findById(treatmentId)
                .orElseThrow(() -> new NoSuchElementException("Treatment not found"));

        if (!treatment.getUser().getId().equals(userId)) {
            throw new SecurityException("Not allowed to delete this treatment");
        }

        treatmentRepository.delete(treatment);
    }
    @Transactional
    public TreatmentResponse update(UUID id, UUID userId, TreatmentRequest request) {
        Treatment treatment = treatmentRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Treatment not found"));

        if (!treatment.getUser().getId().equals(userId)) {
            throw new SecurityException("Not allowed to update this treatment");
        }

        Set<Disease> diseases = new HashSet<>();
        for (UUID diseaseId : request.getDiseaseIds()) {
            Disease disease = diseaseRepository.findById(diseaseId)
                    .orElseThrow(() -> new NoSuchElementException("Disease not found: " + diseaseId));
            diseases.add(disease);
        }

        treatment.setName(request.getName());
        treatment.setStartDate(request.getStartDate());
        treatment.setEndDate(request.getEndDate());
        treatment.setDiseases(diseases);

        return toResponse(treatmentRepository.save(treatment));
    }

    private TreatmentResponse toResponse(Treatment treatment) {
        return new TreatmentResponse(
                treatment.getId(),
                treatment.getName(),
                treatment.getStartDate(),
                treatment.getEndDate(),
                treatment.getDiseases().stream().map(Disease::getName).toList()
        );
    }
}