package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class CreateMedicineRequest {

	@NotBlank(message = "Medication name is required")
	private String medicationName;

	private String dosage;
	private String form;
	private String presentation;
	private String dci;
	private String therapeuticClass;
	private String subClass;
	private String laboratory;
	private String ammNumber;
	private LocalDate ammDate;
	private String primaryPackaging;
	private String packagingSpecification;
	private String scheduleCategory;
	private String shelfLife;
	private String indications;
	private String medicationType;
	private String veicClassification;
	private String barcode;

}