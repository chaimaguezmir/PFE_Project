package com.idvey.afya.controllers;

import com.idvey.afya.payload.request.DiseaseRequest;
import com.idvey.afya.payload.response.DiseaseResponse;
import com.idvey.afya.security.service.DiseaseService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/diseases")
@RequiredArgsConstructor
public class DiseaseController {

	private final DiseaseService diseaseService;

	@PostMapping
	public ResponseEntity<DiseaseResponse> create(@RequestBody DiseaseRequest request) {
		return ResponseEntity.ok(diseaseService.create(request));
	}

	@GetMapping
	public ResponseEntity<List<DiseaseResponse>> getAll() {
		return ResponseEntity.ok(diseaseService.getAll());
	}

	@GetMapping("/search/{name}")
	public ResponseEntity<List<DiseaseResponse>> search(@PathVariable String name) {
		return ResponseEntity.ok(diseaseService.searchByName(name));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable UUID id) {
		diseaseService.delete(id);
		return ResponseEntity.noContent().build();
	}

}