package com.idvey.afya.payload.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MedicationRequest {

	private String barcode;

	private String name;

	private String code;

	private String manufacturer;

}
