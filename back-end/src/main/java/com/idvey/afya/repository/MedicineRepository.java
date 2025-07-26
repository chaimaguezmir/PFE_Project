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

	Optional<Medicine> findByName(String name);

	List<Medicine> findByNameContainingIgnoreCase(String name);

	List<Medicine> findByManufacturerContainingIgnoreCase(String manufacturer);

	Optional<Medicine> findByBarcode(String barcode);

	List<Medicine> findByRequiresPrescription(boolean requiresPrescription);

	List<Medicine> findByDosageForm(String dosageForm);

	@Query("SELECT m FROM Medicine m WHERE " + "LOWER(m.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR "
			+ "LOWER(m.manufacturer) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
	List<Medicine> searchMedicines(@Param("searchTerm") String searchTerm);

	boolean existsByBarcode(String barcode);

	boolean existsByName(String name);

}