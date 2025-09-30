package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class UserHealthProfileResponse {
    private Double weight;
    private Double height;
    private String bloodGroup;
    private String gender;
    private String birthDate;
    private boolean smokingStatus;
    private boolean alcoholConsumption;
    private boolean exerciseRegularly;
    private boolean familyHistoryHeartDisease;
    private boolean hypertensionHistory;
    private boolean heartDisease;
    private boolean diabetes;
    private boolean cholesterol;
    private boolean allergies;
}

