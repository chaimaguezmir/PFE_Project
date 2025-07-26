package com.idvey.afya.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

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
@Table(name = "diseases")
public class Disease {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@Column(nullable = false, unique = true)
	private String name;

	// Many-to-many relationship with Prescription
	@ManyToMany(mappedBy = "diseases", fetch = FetchType.LAZY)
	@Builder.Default
	private Set<Prescription> prescriptions = new HashSet<>();

}
