package com.idvey.afya.payload.request;

import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
public class PharmacyBoxRequest {
    private UUID groupId;
}