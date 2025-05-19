package com.idvey.afya.controllers;

import com.idvey.afya.payload.request.group.AddMemberRequest;
import com.idvey.afya.payload.request.group.CreateGroupRequest;
import com.idvey.afya.payload.request.group.RenameGroupRequest;
import com.idvey.afya.payload.response.GroupMemberResponse;
import com.idvey.afya.payload.response.GroupResponse;
import com.idvey.afya.payload.response.MessageResponse;

import com.idvey.afya.security.service.GroupService;
import com.idvey.afya.security.service.UserDetailsImpl;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.nio.file.AccessDeniedException;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/groups")
@Validated
public class GroupController {

    @Autowired
    private GroupService groupService;

    @GetMapping
    public ResponseEntity<List<GroupResponse>> listMyGroups(
            @AuthenticationPrincipal UserDetailsImpl currentUser
    ) {
        return ResponseEntity.ok(
                groupService.getUserGroups(currentUser.getId())
        );
    }

    @PostMapping
    public ResponseEntity<UUID> createGroup(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @Valid @RequestBody CreateGroupRequest req) {
        return ResponseEntity.ok(
                groupService.createGroup(currentUser.getId(), req.getName())
        );
    }

    @GetMapping("/{groupId}/members")
    public ResponseEntity<List<GroupMemberResponse>> listMembers(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID groupId) {
        var members = groupService.getMembers(groupId);
        var resp = members.stream()
                .map(m -> new GroupMemberResponse(
                        m.getUser().getId(),
                        m.getUser().getUsername(),
                        m.getRole()))
                .collect(Collectors.toList());
        return ResponseEntity.ok(resp);
    }

    @PostMapping("/{groupId}/members")
    public ResponseEntity<MessageResponse> addMember(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID groupId,
            @Valid @RequestBody AddMemberRequest req) throws AccessDeniedException {
        groupService.addUserToGroup(
                groupId,
                currentUser.getId(),
                req.getUsername());
        return ResponseEntity.ok(
                new MessageResponse("User added to group successfully")
        );
    }

    @PatchMapping("/{groupId}")
    public ResponseEntity<MessageResponse> renameGroup(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID groupId,
            @Valid @RequestBody RenameGroupRequest req) throws AccessDeniedException {
        groupService.renameGroup(
                groupId,
                currentUser.getId(),
                req.getName());
        return ResponseEntity.ok(
                new MessageResponse("Group renamed successfully")
        );
    }

    @DeleteMapping("/{groupId}/leave")
    public ResponseEntity<MessageResponse> leaveGroup(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID groupId) {
        groupService.leaveGroup(groupId, currentUser.getId());
        return ResponseEntity.ok(
                new MessageResponse("You have left the group")
        );
    }

    @DeleteMapping("/{groupId}/members/{userId}")
    public ResponseEntity<MessageResponse> removeMember(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @PathVariable UUID groupId,
            @PathVariable UUID userId) throws AccessDeniedException {
        groupService.removeUserFromGroup(
                groupId,
                currentUser.getId(),
                userId);
        return ResponseEntity.ok(
                new MessageResponse("User removed from group successfully")
        );

    }


}
