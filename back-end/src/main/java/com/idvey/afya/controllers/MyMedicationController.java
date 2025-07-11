package com.idvey.afya.controllers;

import com.idvey.afya.payload.request.MyMedicationUpdateRequest;
import com.idvey.afya.payload.request.MyMedicationRequest;
import com.idvey.afya.payload.response.MyMedicationResponse;
import com.idvey.afya.security.service.MyMedicationService;
import com.idvey.afya.security.service.UserDetailsImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/my-medications")
@RequiredArgsConstructor
public class MyMedicationController {

	private final MyMedicationService myMedicationService;

	@PostMapping
	public ResponseEntity<MyMedicationResponse> addMedication(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@RequestBody MyMedicationRequest request) {
		return ResponseEntity.ok(myMedicationService.create(request, currentUser.getId()));
	}

	@GetMapping("/box/{boxId}")
	public ResponseEntity<List<MyMedicationResponse>> getByBox(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID boxId) {
		return ResponseEntity.ok(myMedicationService.getByBox(boxId, currentUser.getId()));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@AuthenticationPrincipal UserDetailsImpl currentUser, @PathVariable UUID id) {
		myMedicationService.delete(id, currentUser.getId());
		return ResponseEntity.noContent().build();
	}

	@PutMapping("/{id}")
	public ResponseEntity<MyMedicationResponse> update(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@PathVariable UUID id, @RequestBody MyMedicationUpdateRequest request) {
		return ResponseEntity.ok(myMedicationService.update(id, currentUser.getId(), request));
	}

}
