package com.idvey.afya.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "treatments")
public class Treatment {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@Column(name = "dosage", nullable = false)
	private String dosage; // e.g., "2 tablets", "5ml", "1 capsule"

	@Column(name = "frequency", nullable = false)
	private String frequency; // e.g., "daily", "day Oter day", "weekly" , "monthly"

	@Column(name = "duration_days")
	private Integer durationDays; // Duration in days

	@Column(name = "created_at", nullable = false, updatable = false)
	@CreationTimestamp
	private LocalDateTime createdAt;

	@Column(name = "updated_at")
	@UpdateTimestamp
	private LocalDateTime updatedAt;

	// Many-to-one relationship with Prescription
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "prescription_id", nullable = false)
	private Prescription prescription;

	// Many-to-one relationship with MyMedicine
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "my_medicine_id", nullable = false)
	private MyMedicine myMedicine;

	// One-to-many relationship with Reminder
	@OneToMany(mappedBy = "treatment", cascade = CascadeType.ALL, orphanRemoval = true)
	@Builder.Default
	private Set<Reminder> reminders = new HashSet<>();

}