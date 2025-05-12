package com.idvey.afya.security.service;

import com.idvey.afya.models.ActivationCode;
import com.idvey.afya.models.User;
import com.idvey.afya.repository.ActivationCodeRepository;
import com.idvey.afya.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.Random;
import java.util.UUID;

import static org.springframework.http.HttpStatus.BAD_REQUEST;

@Service
public class ActivationCodeService {
    private static final int EXPIRATION_MINUTES = 5;

    @Autowired
    private ActivationCodeRepository codeRepo;
    @Autowired
    private UserRepository userRepo;

    @Transactional
    public ActivationCode createCodeFor(User user) {
        // delete old code if exists
        ActivationCode old = user.getActivationCode();
        if (old != null) {
            codeRepo.delete(old);
            codeRepo.flush();              // ⬅️ force the DELETE now
        }

        int code = new Random().ints(1, 100000, 999999).sum();
        String codeStr = String.valueOf(code);
        Date expiry = Date.from(Instant.now().plus(EXPIRATION_MINUTES, ChronoUnit.MINUTES));
        ActivationCode ac = ActivationCode.builder()
                .user(user)
                .code(codeStr)
                .expiryDate(expiry)
                .build();

        user.setActivationCode(ac);
        userRepo.save(user);    // cascades save of ActivationCode
        return ac;
    }

    @Transactional
    public void activate(UUID userId, String code) {
        ActivationCode ac = codeRepo.findByCode(code)
                .orElseThrow(() ->
                        new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid activation code")
                );
        User user = ac.getUser();

        if (!user.getId().equals(userId)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Activation code does not match user"
            );
        }
        if (ac.getExpiryDate().before(new Date())) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Activation code expired"
            );
        }

        user.setEnabled(true);
        user.setActivationCode(null);
        userRepo.save(user);
    }
}