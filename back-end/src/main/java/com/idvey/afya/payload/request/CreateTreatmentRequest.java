package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
public class CreateTreatmentRequest {

	@NotNull(message = "Prescription ID is required")
	private UUID prescriptionId;

	@NotNull(message = "MyMedicine ID is required")
	private UUID myMedicineId;

	@NotBlank(message = "Dosage is required")
	private String dosage;

	@NotBlank(message = "Frequency is required")
	private String frequency;

	@NotNull(message = "Duration in days is required")
	@Positive(message = "Duration must be positive")
	private Integer durationDays;

}