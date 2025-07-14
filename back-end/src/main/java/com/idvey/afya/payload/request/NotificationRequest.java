package com.idvey.afya.payload.request;

import com.idvey.afya.models.NotificationStatus;
import lombok.Data;

import java.time.LocalTime;

@Data
public class NotificationRequest {
    private String label; // ex: "Matin"
    private LocalTime time;
    private NotificationStatus status;
}
