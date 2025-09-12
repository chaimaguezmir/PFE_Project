package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
public class CreateMyMedicineRequest {

	@NotNull(message = "Pharmacy box ID is required")
	private UUID pharmacyBoxId;

	// CHANGED: Made medicineId optional (nullable)
	private UUID medicineId; // Can be null for custom medicines

	@NotBlank(message = "Medicine name is required")
	private String name; // User can customize the name

	private String form; // pill, sachet, tablet, etc. (customizable by user)

	// Additional fields for custom medicines when medicineId is null
	private String manufacturer = "Unknown";

	private String designation;

	private String dosage;

	private String customForm;

	private boolean requiresPrescription = false;

}