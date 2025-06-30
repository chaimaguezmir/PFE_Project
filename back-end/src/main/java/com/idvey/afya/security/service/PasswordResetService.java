package com.idvey.afya.security.service;

import com.idvey.afya.models.PasswordResetToken;
import com.idvey.afya.models.User;
import com.idvey.afya.repository.PasswordResetTokenRepository;
import com.idvey.afya.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.Instant;

@Service
public class PasswordResetService {

	@Value("${afya.app.resetPasswordTokenExpirationMs}")
	private Long resetTokenDurationMs;

	@Autowired
	private PasswordResetTokenRepository tokenRepo;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private EmailService emailService;

	@Transactional
	public void sendResetCode(String email) {
		User user = userRepository.findByEmail(email)
			.orElseThrow(() -> new UsernameNotFoundException("Email not found"));

		// 2. Delete any existing reset-token for this user & flush immediately
		tokenRepo.findByUser_Id(user.getId()).ifPresent(old -> {
			tokenRepo.delete(old);
			tokenRepo.flush();
		});

		// Create new 6-digit code
		String code = String.format("%06d", new SecureRandom().nextInt(1_000_000));
		PasswordResetToken prt = new PasswordResetToken();
		prt.setUser(user);
		prt.setCode(code);
		prt.setExpiryDate(Instant.now().plusMillis(resetTokenDurationMs));
		tokenRepo.save(prt);

		emailService.sendActivationEmail(user.getEmail(), user.getFirstName(), code);
	}

	@Transactional
	public void resetPassword(String email, String code, String newPassword) {
		User user = userRepository.findByEmail(email)
				.orElseThrow(() -> new UsernameNotFoundException("Email not found"));

		PasswordResetToken prt = tokenRepo.findByUser_Id(user.getId())
				.filter(token -> token.getCode().equals(code))
				.orElseThrow(() -> new IllegalArgumentException("Invalid reset code"));

		if (prt.getExpiryDate().isBefore(Instant.now())) {
			throw new IllegalArgumentException("Reset code expired");
		}

		user.setPassword(passwordEncoder.encode(newPassword));
		userRepository.save(user);

		tokenRepo.delete(prt);
	}

	public boolean isResetCodeValid(String email, String code) {
		return userRepository.findByEmail(email)
				.flatMap(user -> tokenRepo.findByUser_Id(user.getId()))
				.filter(token -> token.getCode().equals(code) && token.getExpiryDate().isAfter(Instant.now()))
				.isPresent();
	}

}