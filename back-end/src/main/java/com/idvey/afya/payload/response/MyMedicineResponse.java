package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class MyMedicineResponse {

	private UUID id;

	private String name;

	private String form;

	private UUID pharmacyBoxId;

	private String pharmacyBoxName;

	// CHANGED: Made medicine optional
	private MedicineResponse medicine; // Can be null for custom medicines

	// ADDED: Custom medicine info
	private boolean isCustomMedicine;

	private String customManufacturer;

	private String customForm;

	private Boolean customRequiresPrescription;

	private int totalQuantityPurchased;

	private long purchaseHistoryCount;

	private LocalDateTime createdAt;

	private LocalDateTime updatedAt;

}