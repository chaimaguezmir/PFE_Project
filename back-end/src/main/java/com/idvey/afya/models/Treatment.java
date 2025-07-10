package com.idvey.afya.models;
import jakarta.persistence.*;
import lombok.*;

import java.util.*;


@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Treatment {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(optional = false)
    private User user;

    private String name;

    @ManyToMany
    @JoinTable(
            name = "treatment_disease",
            joinColumns = @JoinColumn(name = "treatment_id"),
            inverseJoinColumns = @JoinColumn(name = "disease_id")
    )
    private Set<Disease> diseases = new HashSet<>();

    private Date startDate;
    private Date endDate;

    @OneToMany(mappedBy = "treatment", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Prescription> prescriptions = new ArrayList<>();
}