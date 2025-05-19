package com.idvey.afya.models;

import com.idvey.afya.models.groupe.GroupMember;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Setter
@Getter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "users",
		uniqueConstraints = { @UniqueConstraint(columnNames = "username"), @UniqueConstraint(columnNames = "email") })
public class User {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@NotBlank
	@Size(max = 20)
	@Column
	private String username;

	@NotBlank
	@Size(max = 50)
	@Email
	@Column
	private String email;

	@NotBlank
	@Size(max = 120)
	@Column
	private String password;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "user_roles", joinColumns = @JoinColumn(name = "user_id"),
			inverseJoinColumns = @JoinColumn(name = "role_id"))
	private Set<Role> roles = new HashSet<>();

	@Column(name = "first_name")
	private String firstName;

	@Column(name = "last_name")
	private String lastName;

	@Column(name = "phone_number")
	private String phoneNumber;

	@Column(name = "weight")
	private Double weight;

	@Column(name = "height")
	private Double height;

	@Column(name = "blood_group")
	private String bloodGroup;

	@Column(name = "gender")
	private String gender;

	@Column(name = "birth_date")
	private String birthDate;

	@Column(name = "smoking_status")
	private boolean smokingStatus;

	@Column(name = "alcohol_consumption")
	private boolean alcoholConsumption;

	@Column(name = "exercise_regularly")
	private boolean exerciseRegularly;

	@Column(name = "family_history_heart_disease")
	private boolean familyHistoryHeartDisease;

	@Column(name = "family_history_diabetes")
	private boolean hypertensionHistory;

	@Column(name = "heart_disease")
	private boolean heartDisease;

	@Column(name = "diabetes")
	private boolean diabetes;

	@Column(name = "cholesterol")
	private boolean cholesterol;

	@Column(name = "allergies")
	private boolean allergies;

	// account activation
	@OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
	private ActivationCode activationCode;

	@Column(name = "enabled", nullable = false)
	private boolean enabled = false;

	@OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
	private Set<GroupMember> groupMemberships = new HashSet<>();

}