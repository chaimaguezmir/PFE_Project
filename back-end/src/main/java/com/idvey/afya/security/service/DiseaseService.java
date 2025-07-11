package com.idvey.afya.security.service;

import com.idvey.afya.models.Disease;
import com.idvey.afya.payload.request.DiseaseRequest;
import com.idvey.afya.payload.response.DiseaseResponse;
import com.idvey.afya.repository.DiseaseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class DiseaseService {

	private final DiseaseRepository diseaseRepository;

	public DiseaseResponse create(DiseaseRequest request) {
		if (diseaseRepository.findByNameIgnoreCase(request.getName()).isPresent()) {
			throw new IllegalStateException("Disease already exists");
		}

		Disease disease = Disease.builder().name(request.getName()).build();

		return toResponse(diseaseRepository.save(disease));
	}

	public List<DiseaseResponse> getAll() {
		return diseaseRepository.findAll().stream().map(this::toResponse).toList();
	}

	public List<DiseaseResponse> searchByName(String name) {
		return diseaseRepository.findByNameContainingIgnoreCase(name).stream().map(this::toResponse).toList();
	}

	public void delete(UUID id) {
		if (!diseaseRepository.existsById(id)) {
			throw new NoSuchElementException("Disease not found");
		}
		diseaseRepository.deleteById(id);
	}

	private DiseaseResponse toResponse(Disease d) {
		return new DiseaseResponse(d.getId(), d.getName());
	}

}