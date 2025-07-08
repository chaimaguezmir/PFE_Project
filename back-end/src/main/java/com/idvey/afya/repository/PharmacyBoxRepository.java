package com.idvey.afya.repository;

import com.idvey.afya.models.PharmacyBox;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PharmacyBoxRepository extends JpaRepository<PharmacyBox, UUID> {
    Optional<PharmacyBox> findByGroup_Name(String name);

    Optional<PharmacyBox> findByGroup_Id(UUID groupId);

}
