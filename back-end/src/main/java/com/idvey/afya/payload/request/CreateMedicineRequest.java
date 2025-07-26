package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreateMedicineRequest {

	@NotBlank(message = "Medicine name is required")
	private String name;

	private String manufacturer;

	private String dosageForm; // tablet, capsule, syrup, injection, etc.

	private boolean requiresPrescription = false;

	private String barcode;

}