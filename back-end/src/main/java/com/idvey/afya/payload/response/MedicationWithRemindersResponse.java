package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class MedicationWithRemindersResponse {

    private UUID myMedicineId;
    private String medicationName;
    private UUID prescriptionId;
    private String prescriptionName;
    private int totalReminders;
    private List<ReminderResponse> reminders;

}