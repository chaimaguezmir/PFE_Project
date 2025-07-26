package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class CreateReminderBulkResponse {

	private UUID treatmentId;

	private String treatmentInfo; // e.g., "Metformin - 2 tablets daily for 7 days"

	private int totalRemindersCreated;

	private List<ReminderResponse> reminders;

	private ReminderCreationSummary summary;

}