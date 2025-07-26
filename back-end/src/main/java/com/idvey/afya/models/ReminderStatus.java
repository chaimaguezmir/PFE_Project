package com.idvey.afya.models;

public enum ReminderStatus {

	/**
	 * Reminder is scheduled and waiting to be triggered
	 */
	SCHEDULED,

	/**
	 * Reminder has been sent/triggered but not yet responded to
	 */
	ACTIVE,

	/**
	 * User confirmed they took the medication
	 */
	TAKEN,

	/**
	 * User missed the reminder (no response within time window)
	 */
	MISSED,

	/**
	 * User snoozed the reminder for later
	 */
	SNOOZED,

	/**
	 * User dismissed/cancelled the reminder
	 */
	DISMISSED,

	/**
	 * Reminder is disabled/inactive
	 */
	INACTIVE

}