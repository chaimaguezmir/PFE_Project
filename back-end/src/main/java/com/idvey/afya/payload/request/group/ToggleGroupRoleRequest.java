package com.idvey.afya.payload.request.group;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;
@Getter
@Setter
public class ToggleGroupRoleRequest {
    @NotNull(message = "Group ID is required")
    private UUID groupId;

    @NotNull(message = "Target user ID is required")
    private UUID targetUserId;


    }