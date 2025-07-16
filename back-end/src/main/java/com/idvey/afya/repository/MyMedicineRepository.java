package com.idvey.afya.repository;

import com.idvey.afya.models.MyMedicine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface MyMedicineRepository extends JpaRepository<MyMedicine, UUID> {

    List<MyMedicine> findByPharmacyBox_Id(UUID pharmacyBoxId);

    List<MyMedicine> findByMedicine_Id(UUID medicineId);

    @Query("SELECT mm FROM MyMedicine mm WHERE mm.pharmacyBox.id = :pharmacyBoxId ORDER BY mm.createdAt DESC")
    List<MyMedicine> findByPharmacyBoxIdOrderByCreatedAtDesc(@Param("pharmacyBoxId") UUID pharmacyBoxId);

    @Query("SELECT mm FROM MyMedicine mm WHERE mm.pharmacyBox.id = :pharmacyBoxId AND LOWER(mm.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<MyMedicine> findByPharmacyBoxIdAndNameContaining(@Param("pharmacyBoxId") UUID pharmacyBoxId, @Param("name") String name);

    @Query("SELECT mm FROM MyMedicine mm WHERE mm.pharmacyBox.id = :pharmacyBoxId AND mm.form = :form")
    List<MyMedicine> findByPharmacyBoxIdAndForm(@Param("pharmacyBoxId") UUID pharmacyBoxId, @Param("form") String form);

    @Query("SELECT mm FROM MyMedicine mm JOIN FETCH mm.medicine WHERE mm.pharmacyBox.id = :pharmacyBoxId")
    List<MyMedicine> findByPharmacyBoxIdWithMedicine(@Param("pharmacyBoxId") UUID pharmacyBoxId);

    @Query("SELECT mm FROM MyMedicine mm JOIN FETCH mm.purchaseHistory WHERE mm.id = :id")
    Optional<MyMedicine> findByIdWithPurchaseHistory(@Param("id") UUID id);

    boolean existsByPharmacyBox_IdAndMedicine_Id(UUID pharmacyBoxId, UUID medicineId);

    @Query("SELECT COUNT(mm) FROM MyMedicine mm WHERE mm.pharmacyBox.id = :pharmacyBoxId")
    long countByPharmacyBoxId(@Param("pharmacyBoxId") UUID pharmacyBoxId);
}