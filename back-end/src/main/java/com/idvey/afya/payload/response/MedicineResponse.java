package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class MedicineResponse {

	private UUID id;

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

	private boolean requiresPrescription; // Computed field

}