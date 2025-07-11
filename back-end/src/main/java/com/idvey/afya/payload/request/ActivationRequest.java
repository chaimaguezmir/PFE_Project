package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActivationRequest {

	@NotBlank
	private String email;

	@NotBlank
	private String code;

	// getters and setters

}