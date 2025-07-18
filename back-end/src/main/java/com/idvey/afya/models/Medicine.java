package com.idvey.afya.models;


import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "medicines")
public class Medicine {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private String name;

    @Column(name = "manufacturer")
    private String manufacturer;

    @Column(name = "dosage_form")
    private String dosageForm; // tablet, capsule, syrup, injection, etc.

    @Column(name = "requires_prescription")
    private boolean requiresPrescription = false;

    @Column(name = "barcode")
    private String barcode;

    // One-to-many relationship with MyMedicine
    @OneToMany(mappedBy = "medicine", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private Set<MyMedicine> myMedicines = new HashSet<>();
}