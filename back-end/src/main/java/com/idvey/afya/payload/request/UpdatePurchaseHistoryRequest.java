package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class UpdatePurchaseHistoryRequest {

	@NotNull(message = "Quantity purchased is required")
	@Positive(message = "Quantity must be positive")
	private Integer quantityPurchased;

	private LocalDate expiryDate;

}