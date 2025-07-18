package com.idvey.afya.payload.request;


import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateMyMedicineRequest {

    @NotBlank(message = "Medicine name is required")
    private String name;

    private String form;
}