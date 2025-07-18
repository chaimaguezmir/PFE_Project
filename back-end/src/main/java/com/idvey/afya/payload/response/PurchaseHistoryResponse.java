package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class PurchaseHistoryResponse {

    private UUID id;
    private Integer quantityPurchased;
    private LocalDate expiryDate;
    private LocalDateTime createdAt;
    private UUID myMedicineId;
    private String myMedicineName;
}