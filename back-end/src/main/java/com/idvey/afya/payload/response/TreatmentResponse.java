package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;


import java.time.LocalDateTime;

import java.util.UUID;
@Getter
@Setter
@AllArgsConstructor
public class TreatmentResponse {

    private UUID id;
    private String dosage;
    private String frequency;
    private Integer durationDays;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private UUID prescriptionId;
    private String prescriptionName;
    private MyMedicineResponse myMedicine;
}