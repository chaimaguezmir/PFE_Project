package com.idvey.afya.payload.response;

import com.idvey.afya.models.groupe.GroupRole;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@AllArgsConstructor
public class UserMedicalSummaryResponse {

	private UUID userId;

	private String username;

	private String email;

	private String firstName;

	private String lastName;

	private String phoneNumber;

	private GroupRole roleInGroup;

	private UserHealthProfileResponse healthProfile;

	private MedicalSummaryResponse medicalSummary;

	private List<PrescriptionResponse> recentPrescriptions;

	private List<TreatmentResponse> recentTreatments;

	private List<ReminderResponse> upcomingReminders;

}
