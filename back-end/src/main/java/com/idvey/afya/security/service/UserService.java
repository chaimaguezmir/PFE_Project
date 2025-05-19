package com.idvey.afya.security.service;

import com.idvey.afya.models.User;
import com.idvey.afya.payload.request.ChangePasswordRequest;
import com.idvey.afya.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Transactional
	public void changePassword(UUID userId, ChangePasswordRequest req) {
		User user = userRepository.findById(userId).orElseThrow(() -> new UsernameNotFoundException("User not found"));

		// 1. Verify old password
		if (!passwordEncoder.matches(req.getOldPassword(), user.getPassword())) {
			throw new BadCredentialsException("Old password is incorrect");
		}

		// 2. Save new password
		user.setPassword(passwordEncoder.encode(req.getNewPassword()));
		userRepository.save(user);
	}

}
