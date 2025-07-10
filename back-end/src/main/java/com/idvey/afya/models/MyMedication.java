package com.idvey.afya.models;


import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MyMedication {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String quantity;
    private String dosage;
    private LocalDate expirationDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pharmacy_box_id", nullable = false)
    private PharmacyBox pharmacyBox;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medication_id", nullable = false)
    private Medication medication;

    @ManyToOne
    @JoinColumn(name = "prescription_id")
    private Prescription prescription;
}
