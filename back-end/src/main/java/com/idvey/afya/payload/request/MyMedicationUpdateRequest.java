package com.idvey.afya.payload.request;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class MyMedicationUpdateRequest {
    private String quantity;
    private LocalDate expirationDate;
}
