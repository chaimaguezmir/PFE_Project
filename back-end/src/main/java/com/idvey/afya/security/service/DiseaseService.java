package com.idvey.afya.security.service;

import com.idvey.afya.models.Disease;
import com.idvey.afya.payload.request.CreateDiseaseRequest;
import com.idvey.afya.payload.response.DiseaseResponse;
import com.idvey.afya.repository.DiseaseRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class DiseaseService {

    private final DiseaseRepository diseaseRepository;

    @Transactional
    public DiseaseResponse createDisease(CreateDiseaseRequest request) {
        log.info("Creating disease with name: {}", request.getName());

        if (diseaseRepository.existsByName(request.getName())) {
            throw new IllegalStateException("Disease with name '" + request.getName() + "' already exists");
        }

        Disease disease = Disease.builder()
                .name(request.getName())
                .build();

        Disease saved = diseaseRepository.save(disease);
        log.info("Disease created with ID: {}", saved.getId());

        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<DiseaseResponse> getAllDiseases() {
        log.info("Fetching all diseases");
        return diseaseRepository.findAllOrderByName()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<DiseaseResponse> searchDiseases(String name) {
        log.info("Searching diseases with name: {}", name);
        return diseaseRepository.findByNameContainingIgnoreCase(name)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public DiseaseResponse getDiseaseById(UUID id) {
        log.info("Fetching disease with ID: {}", id);
        Disease disease = diseaseRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Disease not found with ID: " + id));
        return toResponse(disease);
    }

    private DiseaseResponse toResponse(Disease disease) {
        return new DiseaseResponse(
                disease.getId(),
                disease.getName(),
                disease.getPrescriptions().size()
        );
    }
}