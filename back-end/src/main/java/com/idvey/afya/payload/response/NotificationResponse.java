package com.idvey.afya.payload.response;

import com.idvey.afya.models.NotificationStatus;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalTime;
import java.util.UUID;

@Data
@AllArgsConstructor
public class NotificationResponse {
    private UUID id;
    private String label;
    private LocalTime time;
    private NotificationStatus status;
}