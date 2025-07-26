package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.UUID;

@Getter
@Setter
public class AddPurchaseHistoryRequest {

	@NotNull(message = "My medicine ID is required")
	private UUID myMedicineId;

	@NotNull(message = "Quantity purchased is required")
	@Positive(message = "Quantity must be positive")
	private Integer quantityPurchased;

	private LocalDate expiryDate;

}