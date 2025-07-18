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
@Table(name = "my_medicines")
public class MyMedicine {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private String name; // User can customize the name

    @Column(name = "form")
    private String form; // pill, sachet, tablet, etc. (customizable by user)

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

    // Many-to-one relationship with Medicine
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medicine_id", nullable = false)
    private Medicine medicine;

    // One-to-many relationship with MedicinePurchaseHistory
    @OneToMany(mappedBy = "myMedicine", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private Set<MedicinePurchaseHistory> purchaseHistory = new HashSet<>();


}