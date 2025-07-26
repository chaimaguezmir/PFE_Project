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

	private String dosageForm;

	private boolean requiresPrescription;

	private String barcode;

}
