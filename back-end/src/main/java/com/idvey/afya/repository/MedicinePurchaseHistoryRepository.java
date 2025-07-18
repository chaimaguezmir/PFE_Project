package com.idvey.afya.repository;

import com.idvey.afya.models.MedicinePurchaseHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface MedicinePurchaseHistoryRepository extends JpaRepository<MedicinePurchaseHistory, UUID> {

    List<MedicinePurchaseHistory> findByMyMedicine_Id(UUID myMedicineId);

    @Query("SELECT mph FROM MedicinePurchaseHistory mph WHERE mph.myMedicine.id = :myMedicineId ORDER BY mph.createdAt DESC")
    List<MedicinePurchaseHistory> findByMyMedicineIdOrderByCreatedAtDesc(@Param("myMedicineId") UUID myMedicineId);

    @Query("SELECT mph FROM MedicinePurchaseHistory mph WHERE mph.myMedicine.pharmacyBox.id = :pharmacyBoxId ORDER BY mph.createdAt DESC")
    List<MedicinePurchaseHistory> findByPharmacyBoxIdOrderByCreatedAtDesc(@Param("pharmacyBoxId") UUID pharmacyBoxId);

    @Query("SELECT mph FROM MedicinePurchaseHistory mph WHERE mph.myMedicine.id = :myMedicineId AND mph.createdAt BETWEEN :startDate AND :endDate")
    List<MedicinePurchaseHistory> findByMyMedicineIdAndCreatedAtBetween(@Param("myMedicineId") UUID myMedicineId,
                                                                        @Param("startDate") LocalDateTime startDate,
                                                                        @Param("endDate") LocalDateTime endDate);

    @Query("SELECT mph FROM MedicinePurchaseHistory mph WHERE mph.expiryDate IS NOT NULL AND mph.expiryDate < :date")
    List<MedicinePurchaseHistory> findExpiredPurchases(@Param("date") LocalDate date);

    @Query("SELECT mph FROM MedicinePurchaseHistory mph WHERE mph.expiryDate IS NOT NULL AND mph.expiryDate BETWEEN :startDate AND :endDate")
    List<MedicinePurchaseHistory> findPurchasesExpiringBetween(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    @Query("SELECT SUM(mph.quantityPurchased) FROM MedicinePurchaseHistory mph WHERE mph.myMedicine.id = :myMedicineId")
    Long getTotalQuantityPurchasedByMyMedicine(@Param("myMedicineId") UUID myMedicineId);

    @Query("SELECT COUNT(mph) FROM MedicinePurchaseHistory mph WHERE mph.myMedicine.id = :myMedicineId")
    long countByMyMedicineId(@Param("myMedicineId") UUID myMedicineId);
}