package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreateDiseaseRequest {

    @NotBlank(message = "Disease name is required")
    private String name;
}