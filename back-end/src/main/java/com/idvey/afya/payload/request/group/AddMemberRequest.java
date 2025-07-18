package com.idvey.afya.payload.request.group;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AddMemberRequest {

	@NotBlank
	private String email;

	// getters and setters

}