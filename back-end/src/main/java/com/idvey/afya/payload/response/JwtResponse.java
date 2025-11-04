package com.idvey.afya.payload.response;

import lombok.*;

import java.util.List;
import java.util.UUID;

@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class JwtResponse {

	private String token;

	private String type = "Bearer";

	private String refreshToken;

	private UUID id;

	private String username;

	private String email;

	private List<String> roles;

	private String firstName;

	private String LastName;

	private String deviceName;

	private String deviceId;

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

}