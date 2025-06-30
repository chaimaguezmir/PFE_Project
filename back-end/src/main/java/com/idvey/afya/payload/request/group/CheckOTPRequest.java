package com.idvey.afya.payload.request.group;

import jakarta.validation.constraints.NotBlank;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CheckOTPRequest {

    @NotBlank
    private String email;

    @NotBlank
    private String code;
}