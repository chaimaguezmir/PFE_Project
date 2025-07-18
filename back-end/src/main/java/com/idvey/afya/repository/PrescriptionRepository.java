package com.idvey.afya.repository;

import com.idvey.afya.models.Prescription;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface PrescriptionRepository extends JpaRepository<Prescription, UUID> {

    // Find prescriptions by user ID
    List<Prescription> findByUser_Id(UUID userId);

    // Find prescriptions by user ID ordered by creation date
    @Query("SELECT p FROM Prescription p WHERE p.user.id = :userId ORDER BY p.createdAt DESC")
    List<Prescription> findByUserIdOrderByCreatedAtDesc(@Param("userId") UUID userId);

    // Find active prescriptions (not ended yet)
    @Query("SELECT p FROM Prescription p WHERE p.user.id = :userId AND (p.endDate IS NULL OR p.endDate >= :currentDate)")
    List<Prescription> findActiveByUserId(@Param("userId") UUID userId, @Param("currentDate") LocalDate currentDate);

    // Find prescriptions by date range
    @Query("SELECT p FROM Prescription p WHERE p.user.id = :userId AND p.startDate BETWEEN :startDate AND :endDate")
    List<Prescription> findByUserIdAndDateRange(@Param("userId") UUID userId,
                                                @Param("startDate") LocalDate startDate,
                                                @Param("endDate") LocalDate endDate);

    // Find prescriptions with treatments
    @Query("SELECT p FROM Prescription p LEFT JOIN FETCH p.treatments WHERE p.id = :id")
    Optional<Prescription> findByIdWithTreatments(@Param("id") UUID id);

    // Find prescriptions with diseases
    @Query("SELECT p FROM Prescription p LEFT JOIN FETCH p.diseases WHERE p.id = :id")
    Optional<Prescription> findByIdWithDiseases(@Param("id") UUID id);

    // Count prescriptions by user
    long countByUser_Id(UUID userId);
}