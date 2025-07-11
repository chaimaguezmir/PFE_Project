package com.idvey.afya.models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
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

	private String message;

	private LocalDateTime scheduledAt;

	@ManyToOne(optional = false)
	private Prescription prescription;

}