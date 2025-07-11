package com.idvey.afya.repository;

import com.idvey.afya.models.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface TreatmentRepository extends JpaRepository<Treatment, UUID> {

	List<Treatment> findByUser_Id(UUID userId);

}