package com.idvey.afya.payload.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
public class MedicalSummaryResponse {

	private int totalPrescriptions;

	private int activePrescriptions;

	private int expiredPrescriptions;

	private int totalTreatments;

	private int activeTreatments;

	private int completedTreatments;

	private int totalReminders;

	private int scheduledReminders;

	private int takenReminders;

	private int missedReminders;

	private int pendingReminders;

	private LocalDateTime firstPrescriptionDate;

	private LocalDateTime lastPrescriptionDate;

	private LocalDateTime lastActivityDate;

}
