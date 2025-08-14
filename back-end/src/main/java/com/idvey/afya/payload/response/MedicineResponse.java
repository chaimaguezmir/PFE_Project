package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class MedicineResponse {

	private UUID id;

	private String name;

	private String manufacturer;

	private boolean requiresPrescription;

	private String barcode;

	// NEW FIELDS ADDED
	private String designation;

	private String dosage; // Dosage with unit (e.g., "500mg", "10ml")

	private String form; // tablet, capsule, syrup, injection, etc.

}