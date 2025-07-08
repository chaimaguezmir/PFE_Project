package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class MedicationResponse {
    private UUID id;
    private String barcode;
    private String name;
    private String code;
    private String manufacturer;

}