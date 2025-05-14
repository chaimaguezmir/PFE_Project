package com.idvey.afya.payload.request;


import jakarta.validation.constraints.NotBlank;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResetPasswordRequest {
    @NotBlank
    private String code;
    @NotBlank private String newPassword;

}