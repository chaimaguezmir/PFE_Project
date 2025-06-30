package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LogoutDeviceRequest {
    @NotBlank
    private String refreshToken;
    @NotBlank
    private String deviceId;
    @NotBlank
    private String deviceName;






}