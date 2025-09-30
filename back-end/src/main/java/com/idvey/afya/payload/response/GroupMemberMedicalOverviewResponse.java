package com.idvey.afya.payload.response;

import com.idvey.afya.models.groupe.GroupRole;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class GroupMemberMedicalOverviewResponse {
    private UUID userId;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private GroupRole role;
    private int activePrescriptionsCount;
    private int totalTreatmentsCount;
    private int totalRemindersCount;
    private int pendingRemindersCount;
    private LocalDateTime lastPrescriptionDate;
    private LocalDateTime lastTreatmentDate;
    private LocalDateTime lastReminderDate;
    private String bloodGroup;
    private String gender;
    private Double weight;
    private Double height;
}

