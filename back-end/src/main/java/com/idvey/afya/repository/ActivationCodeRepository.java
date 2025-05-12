package com.idvey.afya.repository;

import com.idvey.afya.models.ActivationCode;
import com.idvey.afya.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface ActivationCodeRepository extends JpaRepository<ActivationCode, UUID> {
    Optional<ActivationCode> findByCode(String code);
    Optional<ActivationCode> findByUser(User user);
    @Modifying
    int deleteByUser(User user);
}