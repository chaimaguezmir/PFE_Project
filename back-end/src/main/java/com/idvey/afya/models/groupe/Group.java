package com.idvey.afya.models.groupe;

import com.idvey.afya.models.PharmacyBox;
import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "groups")
public class Group {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@Column(nullable = false)
	private String name;

	// link to members
	@OneToMany(mappedBy = "group", cascade = CascadeType.ALL, orphanRemoval = true)
	private Set<GroupMember> members = new HashSet<>();

	@OneToOne(mappedBy = "group", cascade = CascadeType.ALL, orphanRemoval = true)
	private PharmacyBox pharmacyBox;

}