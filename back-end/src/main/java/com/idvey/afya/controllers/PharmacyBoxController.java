package com.idvey.afya.controllers;

import com.idvey.afya.docs.PharmacyBoxDocs;
import com.idvey.afya.payload.request.PharmacyBoxRequest;
import com.idvey.afya.payload.response.PharmacyBoxResponse;
import com.idvey.afya.security.service.PharmacyBoxService;
import com.idvey.afya.security.service.UserDetailsImpl;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/pharmacy-box")
@RequiredArgsConstructor
@Tag(name = "Pharmacy Box")
public class PharmacyBoxController {

	private final PharmacyBoxService pharmacyBoxService;

	@PharmacyBoxDocs.GetMyPharmacyBoxes
	@GetMapping("/mine")
	public ResponseEntity<List<PharmacyBoxResponse>> getMyBoxes(@AuthenticationPrincipal UserDetailsImpl currentUser) {
		return ResponseEntity.ok(pharmacyBoxService.getByUserId(currentUser.getId()));
	}
}