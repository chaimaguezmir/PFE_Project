package com.idvey.afya.repository;

import com.idvey.afya.models.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface TreatmentRepository extends JpaRepository<Treatment, UUID> {

    // Find treatments by prescription ID
    List<Treatment> findByPrescription_Id(UUID prescriptionId);

    // Find treatments by prescription ID ordered by creation date
    @Query("SELECT t FROM Treatment t WHERE t.prescription.id = :prescriptionId ORDER BY t.createdAt DESC")
    List<Treatment> findByPrescriptionIdOrderByCreatedAtDesc(@Param("prescriptionId") UUID prescriptionId);

    // Find treatments by MyMedicine ID
    List<Treatment> findByMyMedicine_Id(UUID myMedicineId);

    // Find treatments by frequency
    List<Treatment> findByFrequency(String frequency);

    // Find treatments by prescription and medicine
    @Query("SELECT t FROM Treatment t WHERE t.prescription.id = :prescriptionId AND t.myMedicine.id = :myMedicineId")
    List<Treatment> findByPrescriptionIdAndMyMedicineId(@Param("prescriptionId") UUID prescriptionId,
                                                        @Param("myMedicineId") UUID myMedicineId);

    // Count treatments by prescription
    long countByPrescription_Id(UUID prescriptionId);

    // Count treatments by MyMedicine
    long countByMyMedicine_Id(UUID myMedicineId);

    // Find all treatments for a user (across all prescriptions)
    @Query("SELECT t FROM Treatment t WHERE t.prescription.user.id = :userId ORDER BY t.createdAt DESC")
    List<Treatment> findAllByUserId(@Param("userId") UUID userId);

    // Count treatments by user
    @Query("SELECT COUNT(t) FROM Treatment t WHERE t.prescription.user.id = :userId")
    long countByUserId(@Param("userId") UUID userId);
}
