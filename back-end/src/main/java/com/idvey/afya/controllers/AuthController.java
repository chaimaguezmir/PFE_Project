package com.idvey.afya.controllers;

import com.idvey.afya.advice.UnauthorizedException;
import com.idvey.afya.exception.TokenRefreshException;
import com.idvey.afya.models.*;
import com.idvey.afya.payload.request.*;

import com.idvey.afya.payload.request.group.CheckOTPRequest;
import com.idvey.afya.payload.response.JwtResponse;
import com.idvey.afya.payload.response.MessageResponse;
import com.idvey.afya.payload.response.TokenRefreshResponse;
import com.idvey.afya.repository.RefreshTokenRepository;
import com.idvey.afya.repository.RoleRepository;
import com.idvey.afya.repository.UserRepository;
import com.idvey.afya.security.jwt.JwtUtils;
import com.idvey.afya.security.service.*;
import com.idvey.afya.docs.AuthenticationDocs;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.nio.file.AccessDeniedException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
@Tag(name = "Authentication")
public class AuthController {

	@Autowired
	AuthenticationManager authenticationManager;

	@Autowired
	UserRepository userRepository;

	@Autowired
	RoleRepository roleRepository;

	@Autowired
	PasswordEncoder encoder;

	@Autowired
	JwtUtils jwtUtils;

	@Autowired
	RefreshTokenService refreshTokenService;

	@Autowired
	private PasswordResetService passwordResetService;

	@Autowired
	private ActivationCodeService activationCodeService;

	@Autowired
	private EmailService emailService;

	@Autowired
	private UserService userService;

	@Autowired
	private GroupService groupService;

	@Autowired
	private RefreshTokenRepository refreshTokenRepository;

	@AuthenticationDocs.SignIn
	@PostMapping("/signin")
	public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
		String identifier = loginRequest.getEmail();
		User user;
		if (identifier.contains("@")) {
			user = userRepository.findByEmail(identifier)
				.orElseThrow(() -> new UsernameNotFoundException("User Not Found with email: " + identifier));
		}
		else {
			user = userRepository.findByUsername(identifier)
				.orElseThrow(() -> new UsernameNotFoundException("User Not Found with username: " + identifier));
		}

		if (!user.isEnabled()) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN)
				.body(new MessageResponse(
						"Error: Account not activated. Please check your email for the activation code."));
		}

		Authentication authentication = authenticationManager
			.authenticate(new UsernamePasswordAuthenticationToken(user.getUsername(), loginRequest.getPassword()));

		SecurityContextHolder.getContext().setAuthentication(authentication);

		if (loginRequest.getDeviceId() == null || loginRequest.getDeviceId().isBlank())
			loginRequest.setDeviceId(UUID.randomUUID().toString());
		if (loginRequest.getDeviceName() == null || loginRequest.getDeviceName().isBlank())
			loginRequest.setDeviceName("Unknown Device");

		UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

		String jwt = jwtUtils.generateJwtToken(userDetails);

		List<String> roles = userDetails.getAuthorities()
			.stream()
			.map(GrantedAuthority::getAuthority)
			.collect(Collectors.toList());

		try {
			RefreshToken refreshToken = refreshTokenService.createRefreshToken(userDetails.getId(),
					loginRequest.getDeviceId(), loginRequest.getDeviceName());

			System.out.println(" logged in successfully!");

			JwtResponse jtr = JwtResponse.builder()
				.token(jwt)
				.refreshToken(refreshToken.getToken())
				.id(userDetails.getId())
				.username(userDetails.getUsername())
				.email(userDetails.getEmail())
				.firstName(userDetails.getFirstName())
				.LastName(userDetails.getLastName())
				.phoneNumber(userDetails.getPhoneNumber())
				.weight(userDetails.getWeight())
				.height(userDetails.getHeight())
				.bloodGroup(userDetails.getBloodGroup())
				.gender(userDetails.getGender())
				.birthDate(userDetails.getBirthDate())
				.smokingStatus(userDetails.isSmokingStatus())
				.alcoholConsumption(userDetails.isAlcoholConsumption())
				.exerciseRegularly(userDetails.isExerciseRegularly())
				.familyHistoryHeartDisease(userDetails.isFamilyHistoryHeartDisease())
				.hypertensionHistory(userDetails.isHypertensionHistory())
				.heartDisease(userDetails.isHeartDisease())
				.diabetes(userDetails.isDiabetes())
				.cholesterol(userDetails.isCholesterol())
				.allergies(userDetails.isAllergies())
				.profileImageUrl(userDetails.getProfileImageUrl()) // NOW IT WORKS!
				.deviceName(refreshToken.getDeviceName())
				.deviceId(refreshToken.getDeviceId())
				.roles(roles)
				.type("Bearer")
				.build();

			return ResponseEntity.ok(jtr);

		}
		catch (TokenRefreshException tre) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new MessageResponse(tre.getMessage()));
		}
	}

	@Transactional
	@AuthenticationDocs.SignUp
	@PostMapping("/signup")
	public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
		if (userRepository.existsByUsername(signUpRequest.getUsername())) {
			System.out.println("Error: Username is already taken!");
			return ResponseEntity.badRequest().body(new MessageResponse("Error: Username is already taken!"));
		}

		if (userRepository.existsByEmail(signUpRequest.getEmail())) {
			System.out.println("Error: Email is already in use!");
			return ResponseEntity.badRequest().body(new MessageResponse("Error: Email is already in use!"));
		}

		// Create new user's account
		User user = User.builder()
			.username(signUpRequest.getUsername())
			.email(signUpRequest.getEmail())
			.password(encoder.encode(signUpRequest.getPassword()))
			.firstName(signUpRequest.getFirstName())
			.lastName(signUpRequest.getLastName())
			.phoneNumber(signUpRequest.getPhoneNumber())
			.weight(signUpRequest.getWeight())
			.height(signUpRequest.getHeight())
			.bloodGroup(signUpRequest.getBloodGroup())
			.gender(signUpRequest.getGender())
			.birthDate(signUpRequest.getBirthDate())
			.smokingStatus(signUpRequest.isSmokingStatus())
			.alcoholConsumption(signUpRequest.isAlcoholConsumption())
			.exerciseRegularly(signUpRequest.isExerciseRegularly())
			.familyHistoryHeartDisease(signUpRequest.isFamilyHistoryHeartDisease())
			.hypertensionHistory(signUpRequest.isHypertensionHistory())
			.heartDisease(signUpRequest.isHeartDisease())
			.diabetes(signUpRequest.isDiabetes())
			.cholesterol(signUpRequest.isCholesterol())
			.allergies(signUpRequest.isAllergies())
			.build();

		Set<String> strRoles = signUpRequest.getRole();
		Set<Role> roles = new HashSet<>();

		if (strRoles == null) {
			Role userRole = roleRepository.findByName(ERole.ROLE_USER)
				.orElseThrow(() -> new RuntimeException("Error: Role is not found."));
			roles.add(userRole);
		} /*
			 * else { strRoles.forEach(role -> { switch (role) { case "admin": Role
			 * adminRole = roleRepository.findByName(ERole.ROLE_ADMIN) .orElseThrow(() ->
			 * new RuntimeException("Error: Role is not found.")); roles.add(adminRole);
			 *
			 * break; case "mod": Role modRole =
			 * roleRepository.findByName(ERole.ROLE_CLIENT) .orElseThrow(() -> new
			 * RuntimeException("Error: Role is not found.")); roles.add(modRole);
			 *
			 * break; default: Role userRole = roleRepository.findByName(ERole.ROLE_USER)
			 * .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
			 * roles.add(userRole); } }); }
			 */

		user.setRoles(roles);
		userRepository.save(user);

		groupService.createGroup(user.getId(), "default");

		// send activation code
		ActivationCode ac = activationCodeService.createCodeFor(user);
		emailService.sendActivationEmail(user.getEmail(), user.getFirstName(), ac.getCode());

		System.out.println("User with ID " + user.getId()
				+ " Registration successful—please check email to activate your account.");
		return ResponseEntity.ok(new MessageResponse("User with ID " + user.getId()
				+ " Registration successful—please check email to activate your account."));
	}

	@AuthenticationDocs.RefreshToken
	@PostMapping("/refreshtoken")
	public ResponseEntity<?> refreshToken(@Valid @RequestBody TokenRefreshRequest request) {
		String requestRefreshToken = request.getRefreshToken();

		return refreshTokenService.findByToken(requestRefreshToken)
			.map(refreshTokenService::verifyExpiration)
			.map(refreshToken -> {
				UUID userId = refreshToken.getUser().getId();
				User user = userRepository.findById(userId)
					.orElseThrow(() -> new TokenRefreshException(requestRefreshToken, "User not found"));

				String token = jwtUtils.generateTokenFromUsername(user.getUsername());
				System.out.println("User with ID " + user.getId() + " refreshed token successfully!");
				return ResponseEntity.ok(new TokenRefreshResponse(token, requestRefreshToken));
			})
			.orElseThrow(() -> new TokenRefreshException(requestRefreshToken, "Refresh token is not in database!"));
	}

	@PostMapping("/signout")
	public ResponseEntity<?> logoutUser(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@Valid @RequestBody LogoutDeviceRequest request) {
		UUID userId = currentUser.getId();

		RefreshToken refreshToken = refreshTokenRepository.findByToken(request.getRefreshToken())
			.orElseThrow(() -> new UnauthorizedException("Invalid refresh token."));

		if (!refreshToken.getUser().getId().equals(userId)) {
			throw new UnauthorizedException("Token does not belong to the authenticated user.");
		}

		if (!refreshToken.getDeviceId().equals(request.getDeviceId())) {
			throw new UnauthorizedException("Device ID mismatch.");
		}
		if (!refreshToken.getDeviceName().equals(request.getDeviceName())) {
			throw new UnauthorizedException("Device Name mismatch.");
		}

		refreshTokenRepository.delete(refreshToken);

		return ResponseEntity.ok(new MessageResponse("Logged out successfully from device " + request.getDeviceName()));
	}

	@PostMapping("/activate")
	public ResponseEntity<?> activate(@Valid @RequestBody ActivationRequest req) {
		try {
			activationCodeService.activateByEmail(req.getEmail(), req.getCode());
			return ResponseEntity.ok(new MessageResponse("Account activated! You can now sign in."));
		}
		catch (ResponseStatusException ex) {
			return ResponseEntity.status(ex.getStatusCode()).body(new MessageResponse(ex.getReason()));
		}
	}

	@PostMapping("/resendActivation")
	public ResponseEntity<?> resend(@Valid @RequestBody ResendActivationRequest req) {
		String email = req.getEmail();
		User user = userRepository.findByEmail(email)
			.orElseThrow(() -> new IllegalArgumentException("Email not found"));
		if (user.isEnabled()) {
			return ResponseEntity.badRequest().body(new MessageResponse("Account already activated."));
		}
		ActivationCode ac = activationCodeService.createCodeFor(user);
		emailService.sendActivationEmail(user.getEmail(), user.getFirstName(), ac.getCode());
		return ResponseEntity.ok(new MessageResponse("Activation code resent—please check your email."));
	}

	@PostMapping("/change-password")
	@PreAuthorize("isAuthenticated()")
	public ResponseEntity<MessageResponse> changePassword(@AuthenticationPrincipal UserDetailsImpl currentUser,
			@Valid @RequestBody ChangePasswordRequest req) {

		userService.changePassword(currentUser.getId(), req);
		return ResponseEntity.ok(new MessageResponse("Password changed successfully"));
	}

	@PostMapping("/forgot-password")
	public ResponseEntity<MessageResponse> forgotPassword(@Valid @RequestBody ForgotPasswordRequest req) {
		passwordResetService.sendResetCode(req.getEmail());
		return ResponseEntity.ok(new MessageResponse("Reset code sent to your email"));
	}

	@PostMapping("/reset-password")
	public ResponseEntity<MessageResponse> resetPassword(@Valid @RequestBody ResetPasswordRequest req) {
		passwordResetService.resetPassword(req.getEmail(), req.getCode(), req.getNewPassword());
		return ResponseEntity.ok(new MessageResponse("Password has been reset successfully"));
	}

	@PostMapping("/check-reset-code")
	public ResponseEntity<MessageResponse> checkResetCode(@RequestBody CheckOTPRequest req) {
		boolean valid = passwordResetService.isResetCodeValid(req.getEmail(), req.getCode());
		if (valid) {
			return ResponseEntity.ok(new MessageResponse("Code is valid"));
		}
		else {
			return ResponseEntity.badRequest().body(new MessageResponse("Invalid or expired code"));
		}
	}

}