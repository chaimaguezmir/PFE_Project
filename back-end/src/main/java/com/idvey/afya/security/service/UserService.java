package com.idvey.afya.security.service;

import com.idvey.afya.models.User;
import com.idvey.afya.payload.request.ChangePasswordRequest;
import com.idvey.afya.payload.request.UpdateUserProfileRequest;
import com.idvey.afya.payload.response.UserProfileResponse;
import com.idvey.afya.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Slf4j
public class UserService {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private FileStorageService fileStorageService;

	@Transactional
	public void changePassword(UUID userId, ChangePasswordRequest req) {
		User user = userRepository.findById(userId).orElseThrow(() -> new UsernameNotFoundException("User not found"));

		if (!passwordEncoder.matches(req.getOldPassword(), user.getPassword())) {
			throw new BadCredentialsException("Old password is incorrect");
		}

		user.setPassword(passwordEncoder.encode(req.getNewPassword()));
		userRepository.save(user);
	}

	@Transactional
	public UserProfileResponse updateUserProfile(UUID userId, UpdateUserProfileRequest request) {
		log.info("Updating profile for user: {}", userId);

		User user = userRepository.findById(userId).orElseThrow(() -> new UsernameNotFoundException("User not found"));

		// Update fields only if provided
		if (request.getUsername() != null && !request.getUsername().equals(user.getUsername())) {
			if (userRepository.existsByUsername(request.getUsername())) {
				throw new IllegalStateException("Username is already taken");
			}
			user.setUsername(request.getUsername());
		}

		if (request.getEmail() != null && !request.getEmail().equals(user.getEmail())) {
			if (userRepository.existsByEmail(request.getEmail())) {
				throw new IllegalStateException("Email is already in use");
			}
			user.setEmail(request.getEmail());
		}

		if (request.getFirstName() != null)
			user.setFirstName(request.getFirstName());
		if (request.getLastName() != null)
			user.setLastName(request.getLastName());
		if (request.getPhoneNumber() != null)
			user.setPhoneNumber(request.getPhoneNumber());
		if (request.getWeight() != null)
			user.setWeight(request.getWeight());
		if (request.getHeight() != null)
			user.setHeight(request.getHeight());
		if (request.getBloodGroup() != null)
			user.setBloodGroup(request.getBloodGroup());
		if (request.getGender() != null)
			user.setGender(request.getGender());
		if (request.getBirthDate() != null)
			user.setBirthDate(request.getBirthDate());
		if (request.getProfileImageUrl() != null)
			user.setProfileImageUrl(request.getProfileImageUrl());

		if (request.getSmokingStatus() != null)
			user.setSmokingStatus(request.getSmokingStatus());
		if (request.getAlcoholConsumption() != null)
			user.setAlcoholConsumption(request.getAlcoholConsumption());
		if (request.getExerciseRegularly() != null)
			user.setExerciseRegularly(request.getExerciseRegularly());
		if (request.getFamilyHistoryHeartDisease() != null)
			user.setFamilyHistoryHeartDisease(request.getFamilyHistoryHeartDisease());
		if (request.getHypertensionHistory() != null)
			user.setHypertensionHistory(request.getHypertensionHistory());
		if (request.getHeartDisease() != null)
			user.setHeartDisease(request.getHeartDisease());
		if (request.getDiabetes() != null)
			user.setDiabetes(request.getDiabetes());
		if (request.getCholesterol() != null)
			user.setCholesterol(request.getCholesterol());
		if (request.getAllergies() != null)
			user.setAllergies(request.getAllergies());

		User updated = userRepository.save(user);
		log.info("Profile updated successfully for user: {}", userId);

		return toUserProfileResponse(updated);
	}

	@Transactional
	public String uploadProfileImage(UUID userId, MultipartFile file) throws IOException {
		log.info("Uploading profile image for user: {}", userId);

		User user = userRepository.findById(userId).orElseThrow(() -> new UsernameNotFoundException("User not found"));

		// Delete old image if exists
		if (user.getProfileImageUrl() != null && !user.getProfileImageUrl().isEmpty()) {
			fileStorageService.deleteProfileImage(user.getProfileImageUrl());
		}

		// Save new image
		String imageUrl = fileStorageService.saveProfileImage(file, userId.toString());

		// Update user profile
		user.setProfileImageUrl(imageUrl);
		userRepository.save(user);

		log.info("Profile image uploaded successfully for user: {}", userId);
		return imageUrl;
	}

	@Transactional
	public void deleteProfileImage(UUID userId) {
		log.info("Deleting profile image for user: {}", userId);

		User user = userRepository.findById(userId).orElseThrow(() -> new UsernameNotFoundException("User not found"));

		if (user.getProfileImageUrl() == null || user.getProfileImageUrl().isEmpty()) {
			throw new IllegalStateException("No profile image to delete");
		}

		// Delete file
		fileStorageService.deleteProfileImage(user.getProfileImageUrl());

		// Update user profile
		user.setProfileImageUrl(null);
		userRepository.save(user);

		log.info("Profile image deleted successfully for user: {}", userId);
	}

	@Transactional
	public UserProfileResponse getUserProfile(UUID userId) {
		log.info("Fetching profile for user: {}", userId);

		User user = userRepository.findById(userId).orElseThrow(() -> new UsernameNotFoundException("User not found"));

		return toUserProfileResponse(user);
	}

	private UserProfileResponse toUserProfileResponse(User user) {
		List<String> roles = user.getRoles().stream().map(role -> role.getName().name()).collect(Collectors.toList());

		return UserProfileResponse.builder()
			.id(user.getId())
			.username(user.getUsername())
			.email(user.getEmail())
			.firstName(user.getFirstName())
			.lastName(user.getLastName())
			.phoneNumber(user.getPhoneNumber())
			.weight(user.getWeight())
			.height(user.getHeight())
			.bloodGroup(user.getBloodGroup())
			.gender(user.getGender())
			.birthDate(user.getBirthDate())
			.smokingStatus(user.isSmokingStatus())
			.alcoholConsumption(user.isAlcoholConsumption())
			.exerciseRegularly(user.isExerciseRegularly())
			.familyHistoryHeartDisease(user.isFamilyHistoryHeartDisease())
			.hypertensionHistory(user.isHypertensionHistory())
			.heartDisease(user.isHeartDisease())
			.diabetes(user.isDiabetes())
			.cholesterol(user.isCholesterol())
			.allergies(user.isAllergies())
			.profileImageUrl(user.getProfileImageUrl())
			.roles(roles)
			.build();
	}

}