package com.idvey.afya.payload.response;

import com.idvey.afya.payload.request.CreateReminderRequest;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;


import java.time.LocalTime;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
public class ReminderCreationSummary {

    private int durationDays;
    private String frequency; // daily, every other day, weekly
    private List<TimeSlotSummary> timeSlots;

    @Getter
    @Setter
    @AllArgsConstructor
    public static class TimeSlotSummary {
        private CreateReminderRequest.TimeSlot timeSlot;
        private LocalTime time;
        private int remindersCreated; // how many reminders created for this time slot
    }
}