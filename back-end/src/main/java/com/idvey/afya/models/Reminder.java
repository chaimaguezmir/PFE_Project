package com.idvey.afya.models;

import com.idvey.afya.payload.request.CreateReminderRequest;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "reminders")
public class Reminder {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@Column(name = "reminder_datetime", nullable = false)
	private LocalDateTime reminderDateTime; // Full date and time for the reminder (e.g.,
											// 2025-07-21T08:30, 2025-07-22T14:00)

	@Enumerated(EnumType.STRING)
	@Column(name = "time_slot")
	private CreateReminderRequest.TimeSlot timeSlot; // MORNING, NOON, EVENING, NIGHT

	@Enumerated(EnumType.STRING)
	@Column(name = "status", nullable = false)
	@Builder.Default
	private ReminderStatus status = ReminderStatus.SCHEDULED; // Current status of the
																// reminder

	@Column(name = "message")
	private String message; // Custom reminder message (optional)

	@Column(name = "created_at", nullable = false, updatable = false)
	@CreationTimestamp
	private LocalDateTime createdAt;

	@Column(name = "updated_at")
	@UpdateTimestamp
	private LocalDateTime updatedAt;

	// Many-to-one relationship with Treatment
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "treatment_id", nullable = false)
	private Treatment treatment;

}