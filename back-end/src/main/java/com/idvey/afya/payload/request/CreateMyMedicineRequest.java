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

	@NotNull(message = "Medicine ID is required")
	private UUID medicineId;

	@NotBlank(message = "Medicine name is required")
	private String name; // User can customize the name

	private String form; // pill, sachet, tablet, etc. (customizable by user)

}