package com.idvey.afya.repository;

import com.idvey.afya.models.Medication;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface MedicationRepository extends JpaRepository<Medication, UUID> {

	List<Medication> findByNameContainingIgnoreCase(String name);

	Optional<Medication> findByBarcode(String barcode);

	boolean existsByBarcode(String barcode);

}
