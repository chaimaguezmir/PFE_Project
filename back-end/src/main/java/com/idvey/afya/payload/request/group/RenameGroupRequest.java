package com.idvey.afya.payload.request.group;


import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RenameGroupRequest {

    @NotBlank(message = "Group name must not be blank")
    private String name;
}