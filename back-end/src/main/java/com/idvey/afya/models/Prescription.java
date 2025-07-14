package com.idvey.afya.models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Prescription {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	private LocalDate startDate;
	private LocalDate endDate;

	private int dosagePerDay;



	@OneToMany(mappedBy = "prescription", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Notification> notifications = new ArrayList<>();

	@ManyToOne
	@JoinColumn(name = "treatment_id")
	private Treatment treatment;

	@ManyToOne(optional = false, fetch = FetchType.LAZY)
	@JoinColumn(name = "medication_id", nullable = true)
	private Medication medication;
}