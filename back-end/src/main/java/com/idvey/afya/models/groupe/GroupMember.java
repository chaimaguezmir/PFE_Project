package com.idvey.afya.models.groupe;

import com.idvey.afya.models.User;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.io.Serializable;
import java.security.Key;
import java.time.Instant;
import java.util.Objects;
import java.util.UUID;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(
        name = "group_members",
        uniqueConstraints = @UniqueConstraint(
                columnNames = {"group_id", "user_id"}
        )
)
public class GroupMember {

    @EmbeddedId
    private Key id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("groupId")
    private Group group;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private GroupRole role;


    @Column(name = "joined_at", nullable = false, updatable = false)
    @CreationTimestamp
    private Instant joinedAt;



    @Embeddable
    @Getter @Setter
    public static class Key implements Serializable {
        @Column(name = "group_id")
        private UUID groupId;

        @Column(name = "user_id")
        private UUID userId;

        public Key() {}
        public Key(UUID groupId, UUID userId) {
            this.groupId = groupId;
            this.userId  = userId;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Key other)) return false;
            return Objects.equals(groupId, other.groupId)
                    && Objects.equals(userId,  other.userId);
        }

        @Override
        public int hashCode() {
            return Objects.hash(groupId, userId);
        }
    }

}
