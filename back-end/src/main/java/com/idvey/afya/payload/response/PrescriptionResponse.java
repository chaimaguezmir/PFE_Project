package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;
import java.util.UUID;

@Data
@AllArgsConstructor
public class PrescriptionResponse {
    private UUID id;
    private LocalDate startDate;
    private LocalDate endDate;
    private int dosagePerDay;
    private String medicationName;
}