package com.idvey.afya.repository;

import com.idvey.afya.models.MyMedication;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface MyMedicationRepository extends JpaRepository<MyMedication, UUID> {}
