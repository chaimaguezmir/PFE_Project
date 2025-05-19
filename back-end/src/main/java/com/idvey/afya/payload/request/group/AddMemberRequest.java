package com.idvey.afya.payload.request.group;

import com.idvey.afya.models.groupe.GroupRole;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
public class AddMemberRequest {

	@NotBlank(message = "Username must not be blank")
	private String username;

}