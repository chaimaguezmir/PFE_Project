package com.idvey.afya.payload.response;

import com.idvey.afya.models.groupe.GroupRole;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.UUID;

@Getter
@AllArgsConstructor
public class GroupResponse {

	private UUID groupId;

	private String name;

	private GroupRole role;

}
