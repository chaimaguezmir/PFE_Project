package com.idvey.afya.payload.response;

import com.idvey.afya.models.ReminderStatus;
import com.idvey.afya.payload.request.CreateReminderRequest;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class ReminderResponse {

    private UUID id;
    private LocalDateTime reminderTime;
    private ReminderStatus status;
    private String message;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private UUID treatmentId;
    private CreateReminderRequest.TimeSlot timeSlot; // MORNING, NOON, EVENING, NIGHT
}

