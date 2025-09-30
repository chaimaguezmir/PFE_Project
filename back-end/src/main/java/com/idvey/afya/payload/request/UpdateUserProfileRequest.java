package com.idvey.afya.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateUserProfileRequest {

    @Size(min = 3, max = 20)
    private String username;

    @Size(max = 50)
    @Email
    private String email;

    @Size(min = 3, max = 20)
    private String firstName;

    @Size(min = 3, max = 20)
    private String lastName;

    private String phoneNumber;

    private Double weight;

    private Double height;

    @Size(min = 2, max = 2)
    private String bloodGroup;

    private String gender;

    private String birthDate;

    private Boolean smokingStatus;

    private Boolean alcoholConsumption;

    private Boolean exerciseRegularly;

    private Boolean familyHistoryHeartDisease;

    private Boolean hypertensionHistory;

    private Boolean heartDisease;

    private Boolean diabetes;

    private Boolean cholesterol;

    private Boolean allergies;

    private String profileImageUrl;
}