package com.idvey.afya.docs;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;

import java.lang.annotation.*;

@Tag(name = "Authentication", description = "Endpoints for sign-in, sign-up, refresh & sign-out")
public final class AuthenticationDocs {

	private AuthenticationDocs() {
	} // no instantiation

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Authenticate user", description = "Validates credentials and returns JWT + refresh token.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "Authentication successful",
					content = @Content(mediaType = "application/json",
							schema = @Schema(implementation = com.idvey.afya.payload.response.JwtResponse.class))),
			@ApiResponse(responseCode = "400", description = "Bad request (missing/invalid fields)"),
			@ApiResponse(responseCode = "401", description = "Invalid credentials") })
	public @interface SignIn {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Register new user", description = "Creates a new account with ROLE_USER.")
	@ApiResponses({ @ApiResponse(responseCode = "201", description = "User registered successfully"),
			@ApiResponse(responseCode = "400", description = "Username or email already in use") })
	public @interface SignUp {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Refresh access token",
			description = "Exchanges a valid refresh token for a new JWT access token.")
	@ApiResponses({
			@ApiResponse(responseCode = "200", description = "New access token issued",
					content = @Content(mediaType = "application/json",
							schema = @Schema(
									implementation = com.idvey.afya.payload.response.TokenRefreshResponse.class))),
			@ApiResponse(responseCode = "403", description = "Refresh token invalid or expired") })
	public @interface RefreshToken {

	}

	@Target(ElementType.METHOD)
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	@Operation(summary = "Sign out user", description = "Invalidates all refresh tokens for the current user.")
	@ApiResponses({ @ApiResponse(responseCode = "200", description = "Signed out successfully") })
	public @interface SignOut {

	}

}
