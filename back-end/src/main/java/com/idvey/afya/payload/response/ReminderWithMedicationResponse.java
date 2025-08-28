package com.idvey.afya.payload.response;

import com.idvey.afya.models.ReminderStatus;
import com.idvey.afya.payload.request.CreateReminderRequest;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class ReminderWithMedicationResponse {

    private UUID id;
    private UUID myMedicineId;
    private String medicationName;
    private UUID prescriptionId;
    private String prescriptionName;
    private LocalDateTime reminderTime;
    private ReminderStatus status;
    private String message;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private UUID treatmentId;
    private CreateReminderRequest.TimeSlot timeSlot;

}