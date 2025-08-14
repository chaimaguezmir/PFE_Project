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
@Table(name = "my_medicines")
public class MyMedicine {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@Column(nullable = false)
	private String name; // User can customize the name

	@Column(name = "form")
	private String form; // pill, sachet, tablet, etc. (customizable by user)

	// ADDED: Custom medicine fields (when medicine is null)
	@Column(name = "custom_manufacturer")
	private String customManufacturer;

	@Column(name = "custom_form")
	private String customForm;

	@Column(name = "custom_requires_prescription")
	private Boolean customRequiresPrescription;

	@Column(name = "created_at", nullable = false, updatable = false)
	@CreationTimestamp
	private LocalDateTime createdAt;

	@Column(name = "updated_at")
	@UpdateTimestamp
	private LocalDateTime updatedAt;

	// Many-to-one relationship with PharmacyBox
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "pharmacy_box_id", nullable = false)
	private PharmacyBox pharmacyBox;

	// CHANGED: Made Medicine relationship optional
	@ManyToOne(fetch = FetchType.LAZY, optional = true)
	@JoinColumn(name = "medicine_id", nullable = true)
	private Medicine medicine; // Can be null for custom medicines

	// One-to-many relationship with MedicinePurchaseHistory
	@OneToMany(mappedBy = "myMedicine", cascade = CascadeType.ALL, orphanRemoval = true)
	@Builder.Default
	private Set<MedicinePurchaseHistory> purchaseHistory = new HashSet<>();

	// Helper methods to get effective values
	public String getEffectiveManufacturer() {
		return medicine != null ? medicine.getManufacturer() : customManufacturer;
	}

	public String getEffectiveForm() {
		return medicine != null ? medicine.getForm() : customForm;
	}

	public boolean getEffectiveRequiresPrescription() {
		return medicine != null ? medicine.isRequiresPrescription() :
				(customRequiresPrescription != null ? customRequiresPrescription : false);
	}

	public boolean isCustomMedicine() {
		return medicine == null;
	}
}