package com.idvey.afya.repository;

import com.idvey.afya.models.Medicine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface MedicineRepository extends JpaRepository<Medicine, UUID> {

	// ✅ EXISTING METHODS
	Optional<Medicine> findByName(String name);
	List<Medicine> findByNameContainingIgnoreCase(String name);
	List<Medicine> findByManufacturerContainingIgnoreCase(String manufacturer);
	Optional<Medicine> findByBarcode(String barcode);
	List<Medicine> findByRequiresPrescription(boolean requiresPrescription);
	List<Medicine> findByForm(String form);
	List<Medicine> findByDesignationContainingIgnoreCase(String designation);
	List<Medicine> findByDosageContainingIgnoreCase(String dosage);
	boolean existsByBarcode(String barcode);
	boolean existsByName(String name);

	// ✅ ENHANCED DUPLICATE PREVENTION METHODS

	// Case-insensitive name check
	@Query("SELECT CASE WHEN COUNT(m) > 0 THEN true ELSE false END FROM Medicine m WHERE LOWER(m.name) = LOWER(:name)")
	boolean existsByNameIgnoreCase(@Param("name") String name);

	// Find medicines by name (case-insensitive)
	@Query("SELECT m FROM Medicine m WHERE LOWER(m.name) = LOWER(:name)")
	List<Medicine> findByNameIgnoreCase(@Param("name") String name);

	// Check exact combination of name + dosage + form
	@Query("SELECT CASE WHEN COUNT(m) > 0 THEN true ELSE false END FROM Medicine m WHERE " +
			"LOWER(m.name) = LOWER(:name) AND " +
			"(m.dosage = :dosage OR (m.dosage IS NULL AND :dosage IS NULL)) AND " +
			"(m.form = :form OR (m.form IS NULL AND :form IS NULL))")
	boolean existsByNameAndDosageAndForm(@Param("name") String name,
										 @Param("dosage") String dosage,
										 @Param("form") String form);

	// Find similar medicines (for suggestions)
	@Query("SELECT m FROM Medicine m WHERE " +
			"LOWER(m.name) LIKE LOWER(CONCAT('%', :name, '%')) AND " +
			"(m.dosage = :dosage OR m.form = :form)")
	List<Medicine> findSimilarMedicines(@Param("name") String name,
										@Param("dosage") String dosage,
										@Param("form") String form);

	// Enhanced search across all fields
	@Query("SELECT m FROM Medicine m WHERE " +
			"LOWER(m.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
			"LOWER(m.manufacturer) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
			"LOWER(m.designation) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
			"LOWER(m.dosage) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
			"LOWER(m.form) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
	List<Medicine> searchMedicines(@Param("searchTerm") String searchTerm);

}