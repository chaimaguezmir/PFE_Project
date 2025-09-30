package com.idvey.afya.controllers;

import com.idvey.afya.docs.UserDocs;
import com.idvey.afya.payload.request.UpdateUserProfileRequest;
import com.idvey.afya.payload.response.MessageResponse;
import com.idvey.afya.payload.response.UserProfileResponse;
import com.idvey.afya.security.service.UserDetailsImpl;
import com.idvey.afya.security.service.UserService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Tag(name = "User Profile")
@Slf4j
public class UserController {

    private final UserService userService;

    @UserDocs.GetProfile
    @GetMapping("/profile")
    public ResponseEntity<UserProfileResponse> getUserProfile(
            @AuthenticationPrincipal UserDetailsImpl currentUser) {
        UserProfileResponse profile = userService.getUserProfile(currentUser.getId());
        return ResponseEntity.ok(profile);
    }

    @UserDocs.UpdateProfile
    @PutMapping("/profile")
    public ResponseEntity<UserProfileResponse> updateUserProfile(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @Valid @RequestBody UpdateUserProfileRequest request) {
        UserProfileResponse updated = userService.updateUserProfile(currentUser.getId(), request);
        return ResponseEntity.ok(updated);
    }

    @UserDocs.UploadProfileImage
    @PostMapping("/profile/image")
    public ResponseEntity<MessageResponse> uploadProfileImage(
            @AuthenticationPrincipal UserDetailsImpl currentUser,
            @RequestParam("file") MultipartFile file) {

        try {
            String imageUrl = userService.uploadProfileImage(currentUser.getId(), file);
            return ResponseEntity.ok(
                    new MessageResponse("Profile image uploaded successfully: " + imageUrl)
            );
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse(e.getMessage()));
        } catch (IOException e) {
            log.error("Error uploading profile image", e);
            return ResponseEntity.internalServerError()
                    .body(new MessageResponse("Failed to upload image: " + e.getMessage()));
        }
    }

    @UserDocs.DeleteProfileImage
    @DeleteMapping("/profile/image")
    public ResponseEntity<MessageResponse> deleteProfileImage(
            @AuthenticationPrincipal UserDetailsImpl currentUser) {

        try {
            userService.deleteProfileImage(currentUser.getId());
            return ResponseEntity.ok(
                    new MessageResponse("Profile image deleted successfully")
            );
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse(e.getMessage()));
        }
    }
}