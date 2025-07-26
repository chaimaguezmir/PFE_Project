package com.idvey.afya.repository;

import com.idvey.afya.models.Disease;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface DiseaseRepository extends JpaRepository<Disease, UUID> {

	// Find disease by name
	Optional<Disease> findByName(String name);

	// Find diseases by name containing (case insensitive)
	@Query("SELECT d FROM Disease d WHERE LOWER(d.name) LIKE LOWER(CONCAT('%', :name, '%'))")
	List<Disease> findByNameContainingIgnoreCase(@Param("name") String name);

	// Find diseases with prescriptions
	@Query("SELECT d FROM Disease d LEFT JOIN FETCH d.prescriptions WHERE d.id = :id")
	Optional<Disease> findByIdWithPrescriptions(@Param("id") UUID id);

	// Check if disease exists by name
	boolean existsByName(String name);

	// Find all diseases ordered by name
	@Query("SELECT d FROM Disease d ORDER BY d.name ASC")
	List<Disease> findAllOrderByName();

}