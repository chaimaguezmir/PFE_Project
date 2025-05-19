package com.idvey.afya.models;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.UUID;

@Getter
@Setter
@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "activation_codes")
public class ActivationCode {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@Column(nullable = false, length = 8)
	private String code;

	@Column(name = "expiry_date", nullable = false)
	@Temporal(TemporalType.TIMESTAMP)
	private Date expiryDate;

	@OneToOne
	@JoinColumn(name = "user_id", nullable = false, unique = true)
	private User user;

}