package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
public class UpdatePrescriptionRequest {

    @NotBlank(message = "Prescription name is required")
    private String name;

    @NotNull(message = "Disease IDs are required")
    private List<UUID> diseaseIds;
}