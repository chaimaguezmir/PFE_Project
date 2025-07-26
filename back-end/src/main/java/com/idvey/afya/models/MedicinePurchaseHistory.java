package com.idvey.afya.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "medicine_purchase_history")
public class MedicinePurchaseHistory {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@Column(name = "quantity_purchased", nullable = false)
	private Integer quantityPurchased; // this will be updated when the user purchases
										// consume medicine

	@Column(name = "expiry_date")
	private LocalDate expiryDate;

	@Column(name = "created_at", nullable = false, updatable = false)
	@CreationTimestamp
	private LocalDateTime createdAt;

	// Many-to-one relationship with MyMedicine
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "my_medicine_id", nullable = false)
	private MyMedicine myMedicine;

}