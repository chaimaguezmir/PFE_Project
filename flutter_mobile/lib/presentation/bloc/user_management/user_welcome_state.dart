// lib/presentation/bloc/user_management/user_welcome_state.dart
part of 'user_welcome_cubit.dart';

/// Status enum for form submission states
enum FormzSubmissionStatus {
  initial,
  inProgress,
  success,
  failure
}

class UserWelcomeState extends Equatable {
  const UserWelcomeState({
    this.userId = '',
    this.groupId = '',
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.selectedTimeIndex = -1,
    this.selectedDayIndex = 1,
    this.reminders = const [],
    this.groupedReminders = const {},
    this.todayReminders = const [],
    this.yesterdayReminders = const [],
    this.tomorrowReminders = const [],
  });

  // User and Group identification
  final String userId;
  final String groupId;

  // Loading and error states
  final FormzSubmissionStatus status;
  final String? errorMessage;

  // UI selection states
  final int selectedTimeIndex;
  final int selectedDayIndex;

  // Data states
  final List<ReminderEntity> reminders;
  final Map<String, List<ReminderEntity>> groupedReminders;
  final List<ReminderEntity> todayReminders;
  final List<ReminderEntity> yesterdayReminders;
  final List<ReminderEntity> tomorrowReminders;

  /// Create a copy with updated fields
  UserWelcomeState copyWith({
    String? userId,
    String? groupId,
    FormzSubmissionStatus? status,
    String? errorMessage,
    int? selectedTimeIndex,
    int? selectedDayIndex,
    List<ReminderEntity>? reminders,
    Map<String, List<ReminderEntity>>? groupedReminders,
    List<ReminderEntity>? todayReminders,
    List<ReminderEntity>? yesterdayReminders,
    List<ReminderEntity>? tomorrowReminders,
  }) {
    return UserWelcomeState(
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedTimeIndex: selectedTimeIndex ?? this.selectedTimeIndex,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      reminders: reminders ?? this.reminders,
      groupedReminders: groupedReminders ?? this.groupedReminders,
      todayReminders: todayReminders ?? this.todayReminders,
      yesterdayReminders: yesterdayReminders ?? this.yesterdayReminders,
      tomorrowReminders: tomorrowReminders ?? this.tomorrowReminders,
    );
  }

  // Convenience getters for UI state checks
  bool get isLoading => status == FormzSubmissionStatus.inProgress;
  bool get isSuccess => status == FormzSubmissionStatus.success;
  bool get isFailure => status == FormzSubmissionStatus.failure;
  bool get hasError => errorMessage != null;
  bool get hasReminders => reminders.isNotEmpty;
  bool get hasUserAndGroup => userId.isNotEmpty && groupId.isNotEmpty;

  // Get current selected day reminders
  List<ReminderEntity> get selectedDayReminders {
    switch (selectedDayIndex) {
      case 0:
        return yesterdayReminders;
      case 1:
        return todayReminders;
      case 2:
        return tomorrowReminders;
      default:
        return todayReminders;
    }
  }

  // Check if selected day has reminders
  bool get hasRemindersForSelectedDay => selectedDayReminders.isNotEmpty;

  // Get selected time slot name
  String get selectedTimeSlotName {
    if (selectedTimeIndex == -1) return 'Toutes';
    final timeSlots = ['Matin', 'Après-midi', 'Soir', 'Nuit'];
    return timeSlots[selectedTimeIndex];
  }

  // Get selected day name
  String get selectedDayName {
    switch (selectedDayIndex) {
      case 0:
        return 'Hier';
      case 1:
        return 'Aujourd\'hui';
      case 2:
        return 'Demain';
      default:
        return 'Aujourd\'hui';
    }
  }

  // Statistics getters
  int get totalRemindersToday => todayReminders.length;
  int get takenRemindersToday => todayReminders.where((r) => r.isTaken).length;
  int get overdueRemindersToday => todayReminders.where((r) => r.isOverdue && !r.isTaken).length;
  int get scheduledRemindersToday => todayReminders.where((r) => r.isScheduled).length;
  int get missedRemindersToday => todayReminders.where((r) => r.status.toUpperCase() == 'MISSED').length;

  // Progress calculation
  double get todayProgress {
    if (totalRemindersToday == 0) return 0.0;
    return takenRemindersToday / totalRemindersToday;
  }

  // Check if all today's reminders are completed
  bool get isAllTodayCompleted => totalRemindersToday > 0 && takenRemindersToday == totalRemindersToday;

  // Get urgent reminders (overdue and due now)
  List<ReminderEntity> get urgentReminders {
    return reminders.where((r) =>
    (r.isOverdue || r.isDue) &&
        !r.isTaken &&
        r.status.toUpperCase() != 'MISSED'
    ).toList();
  }

  // Check if there are urgent reminders
  bool get hasUrgentReminders => urgentReminders.isNotEmpty;

  @override
  List<Object?> get props => [
    userId,
    groupId,
    status,
    errorMessage,
    selectedTimeIndex,
    selectedDayIndex,
    reminders,
    groupedReminders,
    todayReminders,
    yesterdayReminders,
    tomorrowReminders,
  ];
}