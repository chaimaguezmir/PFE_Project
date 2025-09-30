package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class UserProfileResponse {
    private UUID id;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private String phoneNumber;
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
    private String profileImageUrl;
    private List<String> roles;
}