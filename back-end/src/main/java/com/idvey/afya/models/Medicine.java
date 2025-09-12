package com.idvey.afya.models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
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

	@Column(name = "medication_name", nullable = false)
	private String medicationName;

	@Column(name = "dosage")
	private String dosage;

	@Column(name = "form")
	private String form;

	@Column(name = "presentation")
	private String presentation;

	@Column(name = "dci")
	private String dci; // International Nonproprietary Name

	@Column(name = "therapeutic_class")
	private String therapeuticClass;

	@Column(name = "sub_class")
	private String subClass;

	@Column(name = "laboratory")
	private String laboratory;

	@Column(name = "amm_number")
	private String ammNumber; // Marketing Authorization Number

	@Column(name = "amm_date")
	private LocalDate ammDate; // Marketing Authorization Date

	@Column(name = "primary_packaging")
	private String primaryPackaging;

	@Column(name = "packaging_specification")
	private String packagingSpecification;

	@Column(name = "schedule_category")
	private String scheduleCategory; // Prescription schedule

	@Column(name = "shelf_life")
	private String shelfLife;

	@Column(name = "indications")
	@Lob
	private String indications; // Medical indications

	@Column(name = "medication_type")
	private String medicationType; // OTC, Prescription, etc.

	@Column(name = "veic_classification")
	private String veicClassification; // Veterinary classification if applicable

	@Column(name = "barcode")
	private String barcode;

	// One-to-many relationship with MyMedicine
	@OneToMany(mappedBy = "medicine", cascade = CascadeType.ALL, orphanRemoval = true)
	@Builder.Default
	private Set<MyMedicine> myMedicines = new HashSet<>();

	// Helper method to check if prescription is required
	public boolean isRequiresPrescription() {
		return medicationType != null && (medicationType.toLowerCase().contains("prescription")
				|| medicationType.toLowerCase().contains("rx"));
	}

}