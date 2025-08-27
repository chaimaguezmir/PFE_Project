package com.idvey.afya.models;

import com.idvey.afya.models.groupe.Group;
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
public class PharmacyBox {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@OneToOne
	@JoinColumn(name = "group_id", nullable = false, unique = true)
	private Group group;

	// One-to-many relationship with MyMedicine
	@OneToMany(mappedBy = "pharmacyBox", cascade = CascadeType.ALL, orphanRemoval = true)
	@Builder.Default
	private Set<MyMedicine> myMedicines = new HashSet<>();

}