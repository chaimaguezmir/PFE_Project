package com.idvey.afya.models.groupe;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;


@Getter @Setter
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
    @OneToMany(
            mappedBy = "group",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private Set<GroupMember> members = new HashSet<>();

    // convenience:
    public void addMember(GroupMember gm) {
        members.add(gm);
        gm.setGroup(this);
    }
    public void removeMember(GroupMember gm) {
        members.remove(gm);
        gm.setGroup(null);
    }
}