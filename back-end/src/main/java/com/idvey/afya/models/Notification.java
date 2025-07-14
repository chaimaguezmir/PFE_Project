package com.idvey.afya.models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Notification {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	private String label; // Exemple : "Matin", "Midi", "Soir", etc.

	private LocalTime time;

	@Enumerated(EnumType.STRING)
	private NotificationStatus status;

	@ManyToOne(optional = false)
	private Prescription prescription;
}