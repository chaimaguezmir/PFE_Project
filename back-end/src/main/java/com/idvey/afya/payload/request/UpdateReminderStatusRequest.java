package com.idvey.afya.payload.request;

import com.idvey.afya.models.ReminderStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateReminderStatusRequest {

    @NotNull(message = "Reminder status is required")
    private ReminderStatus status;
}