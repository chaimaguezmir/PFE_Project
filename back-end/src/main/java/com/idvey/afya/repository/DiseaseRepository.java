package com.idvey.afya.repository;

import com.idvey.afya.models.Disease;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DiseaseRepository extends JpaRepository<Disease, UUID> {

	Optional<Disease> findByNameIgnoreCase(String name);

	List<Disease> findByNameContainingIgnoreCase(String name);

}