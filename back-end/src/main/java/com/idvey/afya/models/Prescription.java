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

	private String doctorName;

	private LocalDate dateIssued;

	@ManyToOne(optional = false)
	private Treatment treatment;

	@OneToMany(mappedBy = "prescription", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Notification> notifications = new ArrayList<>();

	@OneToMany
	@JoinColumn(name = "prescription_id")
	private List<MyMedication> myMedications = new ArrayList<>();

}