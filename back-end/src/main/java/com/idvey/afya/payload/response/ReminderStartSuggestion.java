
package com.idvey.afya.payload.response;

import com.idvey.afya.payload.request.CreateReminderRequest;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
public class ReminderStartSuggestion {

	private LocalTime currentTime;

	private String currentPeriod; // "morning", "noon", "evening", "night"

	private List<StartOption> availableOptions;

	private StartOption recommendedOption;

	@Getter
	@Setter
	@AllArgsConstructor
	public static class StartOption {

		private CreateReminderRequest.StartPreference preference;

		private String description;

		private LocalDateTime firstReminderTime;

		private String explanation;

		private boolean isRecommended;

	}

}