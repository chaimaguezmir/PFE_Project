package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreateMedicineRequest {

	@NotBlank(message = "Medicine name is required")
	private String name;

	private String manufacturer = "Unknown";

	private boolean requiresPrescription = false;

	private String barcode;

	// NEW FIELDS ADDED
	private String designation;

	private String dosage; // Dosage with unit (e.g., "500mg", "10ml")

	private String form; // tablet, capsule, syrup, injection, etc.

}