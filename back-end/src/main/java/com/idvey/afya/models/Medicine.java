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

	@Column(name = "manufacturer", nullable = false)
	@Builder.Default
	private String manufacturer = "Unknown";

	@Column(name = "requires_prescription", nullable = false)
	@Builder.Default
	private boolean requiresPrescription = false;

	@Column(name = "barcode")
	private String barcode;

	// NEW FIELDS ADDED
	@Column(name = "designation")
	private String designation;

	@Column(name = "dosage")
	private String dosage; // Dosage with unit (e.g., "500mg", "10ml")

	@Column(name = "form")
	private String form; // tablet, capsule, syrup, injection, etc.

	// One-to-many relationship with MyMedicine
	@OneToMany(mappedBy = "medicine", cascade = CascadeType.ALL, orphanRemoval = true)
	@Builder.Default
	private Set<MyMedicine> myMedicines = new HashSet<>();

}