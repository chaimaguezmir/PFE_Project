package com.idvey.afya.repository;

import com.idvey.afya.models.Prescription;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface PrescriptionRepository extends JpaRepository<Prescription, UUID> {
    @Query("""
        SELECT p
          FROM Prescription p
          JOIN p.medication m
            JOIN m.myMedications mm
          JOIN mm.pharmacyBox box
          JOIN box.group g
          JOIN g.members gm
         WHERE gm.user.id = :userId
        """)
    List<Prescription> findByUserId(@Param("userId") UUID userId);
}