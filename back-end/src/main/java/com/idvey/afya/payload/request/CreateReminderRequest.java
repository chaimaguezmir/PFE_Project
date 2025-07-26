package com.idvey.afya.payload.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
public class CreateReminderRequest {

	@NotNull(message = "Treatment ID is required")
	private UUID treatmentId;

	@NotEmpty(message = "At least one reminder time is required")
	private List<ReminderTimeSlot> reminderTimes; // List of morning, noon, evening, night
													// times

	private String customMessage; // Optional custom reminder message

	@NotNull(message = "Start preference is required")
	private StartPreference startPreference; // When to start the reminders

	@Getter
	@Setter
	public static class ReminderTimeSlot {

		@NotNull(message = "Time slot is required")
		private TimeSlot timeSlot; // MORNING, NOON, EVENING, NIGHT

		@NotNull(message = "Time is required")
		private LocalTime time; // Actual time like 08:00, 12:00, 18:00, 22:00

	}

	public enum TimeSlot {

		MORNING, // matin
		NOON, // midi
		EVENING, // soir
		NIGHT // nuit

	}

	public enum StartPreference {

		START_NOW, // Start from today if possible
		START_NEXT_CYCLE, // Start from next occurrence of first time slot
		START_TOMORROW // Start from tomorrow

	}

}