package com.idvey.afya.repository;

import com.idvey.afya.models.RefreshToken;
import com.idvey.afya.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface RefreshTokenRepository extends JpaRepository<RefreshToken, UUID> {

	Optional<RefreshToken> findByToken(String token);

	@Modifying
	int deleteByUser(User user);

	/** NEW: lookup a refresh token for this user + device */
	Optional<RefreshToken> findByUserIdAndDeviceId(UUID userId, String deviceId);

}
