package com.idvey.afya.repository;

import com.idvey.afya.models.MyMedication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface MyMedicationRepository extends JpaRepository<MyMedication, UUID> {

    List<MyMedication> findByPharmacyBox_Id(UUID boxId);

    @Query("SELECT m FROM MyMedication m JOIN FETCH m.medication WHERE m.pharmacyBox.id = :boxId")
    List<MyMedication> findByPharmacyBoxIdWithMedication(@Param("boxId") UUID boxId);

    @Query("SELECT m FROM MyMedication m JOIN FETCH m.medication WHERE m.id = :id")
    Optional<MyMedication> findByIdWithMedication(@Param("id") UUID id);

}