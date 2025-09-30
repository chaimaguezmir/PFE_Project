package com.idvey.afya.payload.response;

import com.idvey.afya.models.groupe.GroupRole;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class UserBasicInfoResponse {
    private UUID userId;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private GroupRole roleInGroup;
}

