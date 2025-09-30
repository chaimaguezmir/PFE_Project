package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.lang.annotation.*;

@Tag(name = "User Profile", description = "User profile management - View and update user information")
public final class UserDocs {

    private UserDocs() {} // no instantiation

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Get user profile",
            description = "Retrieves the complete profile information for the authenticated user")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Profile retrieved successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.UserProfileResponse.class))),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface GetProfile {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Update user profile",
            description = "Updates user profile information. Only provided fields will be updated.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Profile updated successfully",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = com.idvey.afya.payload.response.UserProfileResponse.class))),
            @ApiResponse(responseCode = "400", description = "Invalid input data or username/email already exists"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface UpdateProfile {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Upload profile image",
            description = "Uploads a profile image for the authenticated user. Only image files are allowed (max 5MB). If a profile image already exists, it will be automatically replaced.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Image uploaded successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid file, file type, or file size exceeded"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface UploadProfileImage {}

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Operation(summary = "Delete profile image",
            description = "Deletes the current profile image for the authenticated user. The image file will be removed from the server and the database reference will be cleared.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Profile image deleted successfully"),
            @ApiResponse(responseCode = "400", description = "No profile image to delete"),
            @ApiResponse(responseCode = "401", description = "Unauthorized")
    })
    public @interface DeleteProfileImage {}
}