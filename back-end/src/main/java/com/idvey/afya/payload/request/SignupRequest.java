package com.idvey.afya.payload.request;

import jakarta.persistence.Column;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;

@Setter
@Getter
public class SignupRequest {

	@NotBlank
	@Size(min = 3, max = 20)
	private String username;

	@NotBlank
	@Size(max = 50)
	@Email
	private String email;

	private Set<String> role;

	@NotBlank
	@Size(min = 6, max = 40)
	private String password;

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