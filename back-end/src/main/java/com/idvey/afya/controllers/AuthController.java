package com.idvey.afya.controllers;

import com.idvey.afya.exception.TokenRefreshException;
import com.idvey.afya.models.*;
import com.idvey.afya.payload.request.*;
import com.idvey.afya.payload.response.JwtResponse;
import com.idvey.afya.payload.response.MessageResponse;
import com.idvey.afya.payload.response.TokenRefreshResponse;
import com.idvey.afya.repository.RoleRepository;
import com.idvey.afya.repository.UserRepository;
import com.idvey.afya.security.jwt.JwtUtils;
import com.idvey.afya.security.service.ActivationCodeService;
import com.idvey.afya.security.service.EmailService;
import com.idvey.afya.security.service.RefreshTokenService;
import com.idvey.afya.security.service.UserDetailsImpl;
import com.idvey.afya.docs.AuthenticationDocs;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestClient;
import org.springframework.web.server.ResponseStatusException;

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
    private ActivationCodeService activationCodeService;

    @Autowired
    private EmailService emailService;

    @AuthenticationDocs.SignIn
    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {

        User user = userRepository.findByUsername(loginRequest.getUsername())
                .orElseThrow(() -> new UsernameNotFoundException(
                        "User Not Found with username: " + loginRequest.getUsername()));

        if (!user.isEnabled()) {
            return ResponseEntity
                    .status(HttpStatus.FORBIDDEN)
                    .body(new MessageResponse(
                            "Error: Account not activated. Please check your email for the activation code."));
        }
        Authentication authentication = authenticationManager
                .authenticate(new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);

        if (loginRequest.getDeviceId() == null || loginRequest.getDeviceId().isBlank())
            loginRequest.setDeviceId(UUID.randomUUID().toString());
        if (loginRequest.getDeviceName() == null || loginRequest.getDeviceName().isBlank())
            loginRequest.setDeviceName("Unknown Device");

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        String jwt = jwtUtils.generateJwtToken(userDetails);

        List<String> roles = userDetails.getAuthorities().stream().map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());
    try{
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(userDetails.getId(), loginRequest.getDeviceId(), loginRequest.getDeviceName());
        System.out.println(" logged in successfully!");
        JwtResponse jtr = JwtResponse.builder()
                .token(jwt)
                .refreshToken(refreshToken.getToken())
                .id(userDetails.getId())
                .username(userDetails.getUsername())
                .email(userDetails.getEmail())
                .firstName(userDetails.getFirstName())
                .LastName(userDetails.getLastName())
                .deviceName(refreshToken.getDeviceName())
                .deviceId(refreshToken.getDeviceId())
                .roles(roles)
                .type("Bearer")
                .build();
        return ResponseEntity.ok(jtr);

    } catch (TokenRefreshException tre) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new MessageResponse(tre.getMessage()));
    }

    }

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
        } /*else {
      strRoles.forEach(role -> {
        switch (role) {
        case "admin":
          Role adminRole = roleRepository.findByName(ERole.ROLE_ADMIN)
              .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
          roles.add(adminRole);

          break;
        case "mod":
          Role modRole = roleRepository.findByName(ERole.ROLE_CLIENT)
              .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
          roles.add(modRole);

          break;
        default:
          Role userRole = roleRepository.findByName(ERole.ROLE_USER)
              .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
          roles.add(userRole);
        }
      });
    }*/

        user.setRoles(roles);
        userRepository.save(user);

        // send activation code
        ActivationCode ac = activationCodeService.createCodeFor(user);
        emailService.sendActivationEmail(user.getEmail(), user.getFirstName(), ac.getCode());

        System.out.println("User with ID " + user.getId() + " Registration successful—please check email to activate your account.");
        return ResponseEntity.ok(new MessageResponse("User with ID " + user.getId() + " Registration successful—please check email to activate your account."));
    }

    @AuthenticationDocs.RefreshToken
    @PostMapping("/refreshtoken")
    public ResponseEntity<?> refreshToken(@Valid @RequestBody TokenRefreshRequest request) {
        String requestRefreshToken = request.getRefreshToken();

        return refreshTokenService.findByToken(requestRefreshToken)
                .map(refreshTokenService::verifyExpiration)
                .map(RefreshToken::getUser)
                .map(user -> {
                    String token = jwtUtils.generateTokenFromUsername(user.getUsername());
                    System.out.println("User with ID " + user.getId() + " refreshed token successfully!");
                    return ResponseEntity.ok(new TokenRefreshResponse(token, requestRefreshToken));
                })
                .orElseThrow(() -> new TokenRefreshException(requestRefreshToken,
                        "Refresh token is not in database!"));

    }

    @AuthenticationDocs.SignOut
    @PostMapping("/signout")
    public ResponseEntity<?> logoutUser() {
        UserDetailsImpl userDetails = (UserDetailsImpl) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UUID userId = userDetails.getId();
        refreshTokenService.deleteByUserId(userId);
        System.out.println("User with ID " + userId + " Log out successful!");
        return ResponseEntity.ok(new MessageResponse("Log out successful!"));

    }

    @PostMapping("/activate")
    public ResponseEntity<?> activate(@Valid @RequestBody ActivationRequest req) {
        try {
            activationCodeService.activate(req.getUserId(), req.getCode());
            return ResponseEntity
                    .ok(new MessageResponse("Account activated! You can now sign in."));
        } catch (ResponseStatusException ex) {
            // this will give you both status (400/403) and the exact reason
            return ResponseEntity
                    .status(ex.getStatusCode())
                    .body(new MessageResponse(ex.getReason()));
        }
    }

    @PostMapping("/resendActivation")
    public ResponseEntity<?> resend(@Valid @RequestBody ResendActivationRequest req) {
        String email = req.getEmail();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Email not found"));
        if (user.isEnabled()) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Account already activated."));
        }
        ActivationCode ac = activationCodeService.createCodeFor(user);
        emailService.sendActivationEmail(user.getEmail(), user.getFirstName(), ac.getCode());
        return ResponseEntity.ok(new MessageResponse("Activation code resent—please check your email."));
    }

}