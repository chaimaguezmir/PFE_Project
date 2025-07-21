package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;


import java.util.List;

@Getter
@Setter
public class ReminderStartSuggestionRequest {

    @NotEmpty(message = "At least one reminder time is required")
    private List<CreateReminderRequest.ReminderTimeSlot> reminderTimes;
}