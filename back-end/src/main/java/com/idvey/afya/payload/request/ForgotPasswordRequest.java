package com.idvey.afya.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class ForgotPasswordRequest {
    @NotBlank
    @Email
    private String email;

}
