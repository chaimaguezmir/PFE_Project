package com.idvey.afya.repository;

import com.idvey.afya.models.MyMedicine;
import com.idvey.afya.models.Reminder;
import com.idvey.afya.models.ReminderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface ReminderRepository extends JpaRepository<Reminder, UUID> {

	// Find reminders by treatment ID
	List<Reminder> findByTreatment_Id(UUID treatmentId);

	// Find reminders by status
	List<Reminder> findByStatus(ReminderStatus status);

	// Find all reminders for a user (through treatment -> prescription -> user)
	@Query("SELECT r FROM Reminder r WHERE r.treatment.prescription.user.id = :userId")
	List<Reminder> findByUserId(@Param("userId") UUID userId);

	// Find scheduled reminders for a specific datetime (for triggering)
	@Query("SELECT r FROM Reminder r WHERE r.reminderDateTime = :dateTime AND r.status = 'SCHEDULED'")
	List<Reminder> findScheduledRemindersAtDateTime(@Param("dateTime") LocalDateTime dateTime);

	// Find reminders for today
	@Query("SELECT r FROM Reminder r WHERE DATE(r.reminderDateTime) = CURRENT_DATE ORDER BY r.reminderDateTime ASC")
	List<Reminder> findTodaysReminders();

	// Find upcoming reminders (next 24 hours)
	@Query("SELECT r FROM Reminder r WHERE r.reminderDateTime BETWEEN :now AND :tomorrow AND r.status = 'SCHEDULED'")
	List<Reminder> findUpcomingReminders(@Param("now") LocalDateTime now, @Param("tomorrow") LocalDateTime tomorrow);

	// Get all reminders for a specific user with medication and prescription details
	@Query("SELECT r FROM Reminder r " + "JOIN FETCH r.treatment t " + "JOIN FETCH t.prescription p "
			+ "JOIN FETCH t.myMedicine mm " + "WHERE p.user.id = :userId " + "ORDER BY r.reminderDateTime ASC")
	List<Reminder> findAllRemindersByUserIdWithDetails(@Param("userId") UUID userId);

	// Get distinct medications that have reminders for a user
	@Query("SELECT DISTINCT mm FROM Reminder r " + "JOIN r.treatment t " + "JOIN t.myMedicine mm "
			+ "JOIN t.prescription p " + "WHERE p.user.id = :userId")
	List<MyMedicine> findDistinctMedicationsWithReminders(@Param("userId") UUID userId);

	// Get all reminders for a specific MyMedicine
	@Query("SELECT r FROM Reminder r " + "JOIN r.treatment t " + "WHERE t.myMedicine.id = :myMedicineId "
			+ "ORDER BY r.reminderDateTime ASC")
	List<Reminder> findRemindersByMyMedicineId(@Param("myMedicineId") UUID myMedicineId);

}