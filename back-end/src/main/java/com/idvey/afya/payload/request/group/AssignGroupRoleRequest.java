package com.idvey.afya.payload.request.group;

import com.idvey.afya.models.groupe.GroupRole;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AssignGroupRoleRequest {

    @NotNull(message = "Role must not be null")
    private GroupRole role;
}