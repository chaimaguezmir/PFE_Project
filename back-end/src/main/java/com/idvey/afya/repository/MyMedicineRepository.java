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

	@Query("SELECT mm FROM MyMedicine mm LEFT JOIN FETCH mm.medicine WHERE mm.pharmacyBox.id = :pharmacyBoxId")
	List<MyMedicine> findByPharmacyBoxIdWithMedicine(@Param("pharmacyBoxId") UUID pharmacyBoxId);

	@Query("SELECT mm FROM MyMedicine mm LEFT JOIN FETCH mm.purchaseHistory WHERE mm.id = :id")
	Optional<MyMedicine> findByIdWithPurchaseHistory(@Param("id") UUID id);

	// UPDATED: Check for global medicine existence
	boolean existsByPharmacyBox_IdAndMedicine_Id(UUID pharmacyBoxId, UUID medicineId);

	// ADDED: Check for custom medicine with same name
	@Query("SELECT CASE WHEN COUNT(mm) > 0 THEN true ELSE false END FROM MyMedicine mm WHERE mm.pharmacyBox.id = :pharmacyBoxId AND mm.name = :name AND mm.medicine IS NULL")
	boolean existsByPharmacyBox_IdAndNameAndMedicine_IsNull(@Param("pharmacyBoxId") UUID pharmacyBoxId, @Param("name") String name);

	@Query("SELECT COUNT(mm) FROM MyMedicine mm WHERE mm.pharmacyBox.id = :pharmacyBoxId")
	long countByPharmacyBoxId(@Param("pharmacyBoxId") UUID pharmacyBoxId);

	// ADDED: Find custom medicines (where medicine is null)
	@Query("SELECT mm FROM MyMedicine mm WHERE mm.pharmacyBox.id = :pharmacyBoxId AND mm.medicine IS NULL")
	List<MyMedicine> findCustomMedicinesByPharmacyBoxId(@Param("pharmacyBoxId") UUID pharmacyBoxId);

	// ADDED: Find global medicines (where medicine is not null)
	@Query("SELECT mm FROM MyMedicine mm WHERE mm.pharmacyBox.id = :pharmacyBoxId AND mm.medicine IS NOT NULL")
	List<MyMedicine> findGlobalMedicinesByPharmacyBoxId(@Param("pharmacyBoxId") UUID pharmacyBoxId);
}