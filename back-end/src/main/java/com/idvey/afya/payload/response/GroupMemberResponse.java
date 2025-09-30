package com.idvey.afya.payload.response;

import com.idvey.afya.models.groupe.GroupRole;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.UUID;

@Getter
@AllArgsConstructor

public class GroupMemberResponse {

	private UUID userId;

	private String username;

	private GroupRole role;

	private String profileImageUrl; // NEW FIELD

}