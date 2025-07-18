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
    private MedicineResponse medicine;
    private int totalQuantityPurchased;
    private long purchaseHistoryCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}