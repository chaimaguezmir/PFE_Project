package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateMedicineBarcodeRequest {

    @NotBlank(message = "Barcode is required")
    private String barcode;

}