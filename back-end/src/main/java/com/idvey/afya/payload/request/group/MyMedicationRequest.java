package com.idvey.afya.payload.request.group;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.UUID;

@Setter
@Getter
public class MyMedicationRequest {
    private UUID pharmacyBoxId;
    private UUID medicationId;
    private String quantity;
    private LocalDate expirationDate;
}