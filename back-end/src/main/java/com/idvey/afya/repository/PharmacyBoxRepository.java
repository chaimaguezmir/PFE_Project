package com.idvey.afya.repository;

import com.idvey.afya.models.MyMedication;
import com.idvey.afya.models.PharmacyBox;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface PharmacyBoxRepository extends JpaRepository<PharmacyBox, UUID> {
    Optional<PharmacyBox> findByGroup_Name(String name);

    Optional<PharmacyBox> findByGroup_Id(UUID groupId);
    // PharmacyBoxRepository.java
    @Query("SELECT pb FROM PharmacyBox pb LEFT JOIN FETCH pb.medications WHERE pb.id = :id")
    Optional<PharmacyBox> findByIdWithMedications(@Param("id") UUID id);


}
