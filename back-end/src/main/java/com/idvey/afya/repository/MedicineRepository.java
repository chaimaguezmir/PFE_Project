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

	// Find by medication name
	Optional<Medicine> findByMedicationName(String medicationName);

	// Search by medication name (case insensitive)
	List<Medicine> findByMedicationNameContainingIgnoreCase(String medicationName);

	// Search by laboratory (case insensitive)
	List<Medicine> findByLaboratoryContainingIgnoreCase(String laboratory);

	// Find by barcode
	Optional<Medicine> findByBarcode(String barcode);

	// Find by medication type
	List<Medicine> findByMedicationType(String medicationType);

	// Find by therapeutic class
	List<Medicine> findByTherapeuticClass(String therapeuticClass);

	// Find by form
	List<Medicine> findByForm(String form);

	// Find by DCI
	List<Medicine> findByDciContainingIgnoreCase(String dci);

	// Complex search across multiple fields
	@Query("SELECT m FROM Medicine m WHERE " +
			"LOWER(m.medicationName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
			"LOWER(m.laboratory) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
			"LOWER(m.dci) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
			"LOWER(m.therapeuticClass) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
	List<Medicine> searchMedicines(@Param("searchTerm") String searchTerm);

	// Check if barcode exists
	boolean existsByBarcode(String barcode);

	// Check if medication name exists
	boolean existsByMedicationName(String medicationName);

	// Find by AMM number
	Optional<Medicine> findByAmmNumber(String ammNumber);

	// Find by schedule category
	List<Medicine> findByScheduleCategory(String scheduleCategory);

	// Find prescription medicines
	@Query("SELECT m FROM Medicine m WHERE LOWER(m.medicationType) LIKE '%prescription%' OR LOWER(m.medicationType) LIKE '%rx%'")
	List<Medicine> findPrescriptionMedicines();

	// Find OTC medicines
	@Query("SELECT m FROM Medicine m WHERE LOWER(m.medicationType) LIKE '%otc%' OR LOWER(m.medicationType) LIKE '%over%counter%'")
	List<Medicine> findOTCMedicines();

}