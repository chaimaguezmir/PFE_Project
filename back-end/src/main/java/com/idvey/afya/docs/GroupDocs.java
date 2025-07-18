package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import java.lang.annotation.*;

@Tag(name = "Groups", description = "Group management and collaboration")
public final class GroupDocs {

    private GroupDocs() {} // no instantiation

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get my groups", description = "Retrieves all groups the current user belongs to")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Groups retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.GroupResponse.class))),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetMyGroups {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Create group", description = "Creates a new group with the current user as manager")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Group created successfully"),
            @ApiResponse(responseCode = "400", description = "Group name already exists for user"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface CreateGroup {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get group members", description = "Retrieves all members of a specific group")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Group members retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.GroupMemberResponse.class))),
            @ApiResponse(responseCode = "404", description = "Group not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetGroupMembers {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Add member to group", description = "Adds a new member to the group (Manager only)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Member added successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - only managers can add members"),
            @ApiResponse(responseCode = "404", description = "Group or user not found"),
            @ApiResponse(responseCode = "400", description = "User already in group"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface AddMember {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Remove member from group", description = "Removes a member from the group (Manager only)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Member removed successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - only managers can remove members"),
            @ApiResponse(responseCode = "404", description = "Group or user not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface RemoveMember {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Rename group", description = "Changes the name of the group (Manager only)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Group renamed successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - only managers can rename groups"),
            @ApiResponse(responseCode = "400", description = "Group name already exists for user"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface RenameGroup {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Leave group", description = "Removes the current user from the group")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Left group successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
            @ApiResponse(responseCode = "404", description = "Group not found or user not in group"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface LeaveGroup {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Delete group", description = "Deletes the entire group (Manager only)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Group deleted successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - only managers can delete groups"),
            @ApiResponse(responseCode = "404", description = "Group not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface DeleteGroup {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Toggle member role", description = "Toggles member role between MEMBER and RESPONSIBLE (Manager only)")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Role toggled successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.MessageResponse.class))),
            @ApiResponse(responseCode = "403", description = "Access denied - only managers can change roles"),
            @ApiResponse(responseCode = "404", description = "Group or user not found"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface ToggleRole {}
}