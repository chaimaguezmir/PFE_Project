package com.idvey.afya.security.service;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.idvey.afya.models.User;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serial;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDetailsImpl implements UserDetails {
    @Serial
    private static final long serialVersionUID = 1L;

    private UUID id;

    private String username;

    private String email;

    @JsonIgnore
    private String password;

    private String firstName;
    private String lastName;

    private String phoneNumber;
    private Double weight;
    private Double height;
    private String bloodGroup;
    private String gender;
    private String birthDate;
    private boolean smokingStatus;
    private boolean alcoholConsumption;
    private boolean exerciseRegularly;
    private boolean familyHistoryHeartDisease;
    private boolean hypertensionHistory;
    private boolean heartDisease;
    private boolean diabetes;
    private boolean cholesterol;
    private boolean allergies;



    private Collection<? extends GrantedAuthority> authorities;


    public static UserDetailsImpl build(User user) {
        List<GrantedAuthority> authorities = user.getRoles().stream().map(role -> new SimpleGrantedAuthority(role.getName().name())).collect(Collectors.toList());

        return new UserDetailsImpl(user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getPassword(),
                user.getFirstName(),
                user.getLastName(),
                user.getPhoneNumber(),
                user.getWeight(),
                user.getHeight(),
                user.getBloodGroup(),
                user.getGender(),
                user.getBirthDate(),
                user.isSmokingStatus(),
                user.isAlcoholConsumption(),
                user.isExerciseRegularly(),
                user.isFamilyHistoryHeartDisease(),
                user.isHypertensionHistory(),
                user.isHeartDisease(),
                user.isDiabetes(),
                user.isCholesterol(),
                user.isAllergies(),
                authorities);
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserDetailsImpl user = (UserDetailsImpl) o;
        return Objects.equals(id, user.id);
    }
}