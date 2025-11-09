// lib/presentation/bloc/user_management/user_welcome_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/domain/entities/reminder/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/reminder/reminder_extensions.dart';
import 'package:flutter_mobile/domain/repositories/user_reminder_repository.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';

part 'user_welcome_state.dart';

class UserWelcomeCubit extends Cubit<UserWelcomeState> {
  UserWelcomeCubit({required this.userReminderRepository})
    : super(const UserWelcomeState());

  final UserReminderRepository userReminderRepository;

  // Helper: only emit if cubit is still alive
  void safeEmit(UserWelcomeState newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  /// Set the user and group IDs
  void setUserAndGroup(String userId, String groupId) {
    if (isClosed) return;
    safeEmit(state.copyWith(userId: userId, groupId: groupId));
  }

  /// Load initial welcome data for the user
  Future<void> loadWelcomeData(String userId, String groupId) async {
    if (isClosed) return;
    safeEmit(
      state.copyWith(
        userId: userId,
        groupId: groupId,
        status: FormzSubmissionStatus.inProgress,
      ),
    );
    try {
      await fetchReminders();
    } catch (e) {
      if (isClosed) return;
      safeEmit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Fetch reminders from repository for specific user in group
  Future<void> fetchReminders() async {
    if (isClosed) return;

    if (state.userId.isEmpty || state.groupId.isEmpty) {
      safeEmit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'User ID and Group ID are required',
        ),
      );
      return;
    }

    safeEmit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    try {
      final result = await userReminderRepository
          .getUserRemindersWithMedications(
            groupId: state.groupId,
            userId: state.userId,
          );

      if (isClosed) return;

      if (result is DataSuccess<List<ReminderEntity>>) {
        final reminders = result.data ?? [];

        // Process reminders into different time periods
        final groupedReminders = _groupRemindersByTimeSlot(reminders);
        final todayReminders = _getRemindersForDate(reminders, DateTime.now());
        final yesterdayReminders = _getRemindersForDate(
          reminders,
          DateTime.now().subtract(const Duration(days: 1)),
        );
        final tomorrowReminders = _getRemindersForDate(
          reminders,
          DateTime.now().add(const Duration(days: 1)),
        );

        safeEmit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            reminders: reminders,
            groupedReminders: groupedReminders,
            todayReminders: todayReminders,
            yesterdayReminders: yesterdayReminders,
            tomorrowReminders: tomorrowReminders,
            errorMessage: null,
          ),
        );
      } else if (result is DataError) {
        safeEmit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: result.error ?? 'Failed to fetch reminders',
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      safeEmit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'An error occurred: $e',
        ),
      );
    }
  }

  /// Update selected time period index
  void updateSelectedTime(int index) {
    if (isClosed) return;
    safeEmit(state.copyWith(selectedTimeIndex: index));
  }

  /// Update selected day index
  void updateSelectedDay(int dayIndex) {
    if (isClosed) return;
    safeEmit(state.copyWith(selectedDayIndex: dayIndex));
  }

  /// Mark medication as taken
  Future<void> markMedicationAsTaken(String reminderId) async {
    if (isClosed) return;

    try {
      // Call backend to mark as taken
      final result = await userReminderRepository.markUserReminderAsTaken(
        groupId: state.groupId,
        userId: state.userId,
        reminderId: reminderId,
      );

      if (result is DataSuccess) {
        print('✅ User reminder marked as taken successfully: $reminderId');

        // Update local state
        final updatedReminders = state.reminders.map((reminder) {
          if (reminder.id == reminderId) {
            return reminder.copyWith(
              status: 'TAKEN',
              updatedAt: DateTime.now(),
            );
          }
          return reminder;
        }).toList();

        // Recalculate grouped data
        final groupedReminders = _groupRemindersByTimeSlot(updatedReminders);
        final todayReminders = _getTodayReminders(updatedReminders);
        final yesterdayReminders = _getRemindersForDate(
          updatedReminders,
          DateTime.now().subtract(const Duration(days: 1)),
        );
        final tomorrowReminders = _getRemindersForDate(
          updatedReminders,
          DateTime.now().add(const Duration(days: 1)),
        );

        safeEmit(
          state.copyWith(
            reminders: updatedReminders,
            groupedReminders: groupedReminders,
            todayReminders: todayReminders,
            yesterdayReminders: yesterdayReminders,
            tomorrowReminders: tomorrowReminders,
          ),
        );
      } else if (result is DataError) {
        print('❌ Failed to mark user reminder as taken: ${result.error}');
        safeEmit(
          state.copyWith(
            errorMessage: result.error ?? 'Échec de la mise à jour du rappel',
          ),
        );
      }
    } catch (e) {
      print('❌ Exception marking user reminder as taken: $e');
      safeEmit(
        state.copyWith(
          errorMessage: 'Erreur lors de la mise à jour du rappel',
        ),
      );
    }
  }

  /// Snooze reminder (placeholder for future implementation)
  void snoozeReminder(String reminderId) {
    // TODO: Implement snooze functionality
    // This would typically involve updating the reminder time
    print('Snoozing reminder: $reminderId');

    // For now, we can just show a message or update the reminder time
    // In a real implementation, this would make an API call to update the reminder
  }

  /// Group reminders by time slot (morning, noon, evening, night)
  Map<String, List<ReminderEntity>> _groupRemindersByTimeSlot(
    List<ReminderEntity> reminders,
  ) {
    final grouped = <String, List<ReminderEntity>>{
      'MORNING': [],
      'NOON': [],
      'EVENING': [],
      'NIGHT': [],
    };

    for (final reminder in reminders) {
      final normalizedTimeSlot = reminder.normalizedTimeSlot;
      if (grouped.containsKey(normalizedTimeSlot)) {
        grouped[normalizedTimeSlot]!.add(reminder);
      } else {
        // Default to morning if time slot is unknown
        grouped['MORNING']!.add(reminder);
      }
    }

    return grouped;
  }

  /// Get today's reminders
  List<ReminderEntity> _getTodayReminders(List<ReminderEntity> reminders) {
    return _getRemindersForDate(reminders, DateTime.now());
  }

  /// Get reminders for a specific date
  List<ReminderEntity> _getRemindersForDate(
    List<ReminderEntity> reminders,
    DateTime targetDate,
  ) {
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);

    return reminders.where((reminder) {
      final reminderDate = DateTime(
        reminder.reminderTime.year,
        reminder.reminderTime.month,
        reminder.reminderTime.day,
      );
      return reminderDate.isAtSameMomentAs(target);
    }).toList();
  }

  /// Get reminders for currently selected time slot and day
  List<ReminderEntity> getRemindersForSelectedTimeSlot() {
    // First, get reminders for selected day
    List<ReminderEntity> dayReminders;
    switch (state.selectedDayIndex) {
      case 0:
        dayReminders = state.yesterdayReminders;
        break;
      case 1:
        dayReminders = state.todayReminders;
        break;
      case 2:
        dayReminders = state.tomorrowReminders;
        break;
      default:
        dayReminders = state.todayReminders;
    }

    // If no specific time is selected, return all reminders for the day
    if (state.selectedTimeIndex == -1) {
      return dayReminders;
    }

    // Filter by selected time slot
    final timeSlots = ['MORNING', 'NOON', 'EVENING', 'NIGHT'];
    final selectedTimeSlot = timeSlots[state.selectedTimeIndex];

    return dayReminders
        .where((reminder) => reminder.normalizedTimeSlot == selectedTimeSlot)
        .toList();
  }

  /// Get selected day name for display
  String getSelectedDayName() {
    final now = DateTime.now();
    switch (state.selectedDayIndex) {
      case 0:
        final yesterday = now.subtract(const Duration(days: 1));
        return _getDayName(yesterday);
      case 1:
        return _getDayName(now);
      case 2:
        final tomorrow = now.add(const Duration(days: 1));
        return _getDayName(tomorrow);
      default:
        return _getDayName(now);
    }
  }

  /// Get day name in French
  String _getDayName(DateTime date) {
    final days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    return days[date.weekday - 1];
  }

  /// Get display name for time slot
  String getTimeSlotDisplayName(String timeSlot) {
    switch (timeSlot.toUpperCase()) {
      case 'MORNING':
        return 'Matin';
      case 'NOON':
        return 'Après-midi';
      case 'EVENING':
        return 'Soir';
      case 'NIGHT':
        return 'Nuit';
      default:
        return timeSlot;
    }
  }

  /// Get reminder time string (HH:mm format)
  String getReminderTimeString(ReminderEntity reminder) {
    return reminder.timeString;
  }

  /// Check if reminder is due now
  bool isReminderDue(ReminderEntity reminder) {
    return reminder.isDue;
  }

  /// Check if reminder is overdue
  bool isReminderOverdue(ReminderEntity reminder) {
    return reminder.isOverdue;
  }

  /// Get statistics for the current day
  Map<String, int> getDayStatistics() {
    final dayReminders = getRemindersForSelectedTimeSlot();

    int total = dayReminders.length;
    int taken = dayReminders.where((r) => r.isTaken).length;
    int missed = dayReminders
        .where((r) => r.status.toUpperCase() == 'MISSED')
        .length;
    int scheduled = dayReminders.where((r) => r.isScheduled).length;
    int overdue = dayReminders.where((r) => r.isOverdue && !r.isTaken).length;

    return {
      'total': total,
      'taken': taken,
      'missed': missed,
      'scheduled': scheduled,
      'overdue': overdue,
    };
  }

  /// Refresh all data
  Future<void> refresh() async {
    await fetchReminders();
  }

  /// Clear error message
  void clearError() {
    if (isClosed) return;
    safeEmit(state.copyWith(errorMessage: null));
  }

  /// Reset to initial state
  void reset() {
    if (isClosed) return;
    safeEmit(const UserWelcomeState());
  }
}
