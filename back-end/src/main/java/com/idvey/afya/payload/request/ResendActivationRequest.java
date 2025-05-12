package com.idvey.afya.payload.request;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResendActivationRequest {
    @NotBlank
    @Email
    private String email;
}