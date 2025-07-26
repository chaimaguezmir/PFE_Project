package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class PharmacyBoxMedicinesResponse {

	private UUID pharmacyBoxId;

	private String groupName;

	private int totalMedicines;

	private List<MyMedicineResponse> medicines;

}