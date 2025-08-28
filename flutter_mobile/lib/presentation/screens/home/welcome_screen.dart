// lib/presentation/screens/home/welcome_screen.dart - Complete corrected version
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_entity.dart';
import 'package:flutter_mobile/domain/entities/prescription/reminder_extensions.dart';
import 'package:flutter_mobile/presentation/bloc/home/welcome_screen_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger loading when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WelcomeScreenCubit>().loadWelcomeData();
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Accueil",
        username: "Walid Zaroui",
        email: "zarwi.walid@gmail.com",
        avatarPath: "lib/config/assets/images/default_avatar.jpg",
        showLeading: true,
      ),
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<WelcomeScreenCubit, WelcomeScreenState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.errorMessage ?? 'Une erreur est survenue',
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WelcomeScreenCubit>().fetchReminders();
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          return const Column(
            children: [
              _DayHeader(),
              Expanded(child: MedicationScheduleCard()),
            ],
          );
        },
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ClickableDayName(),
          SizedBox(height: 18.h),
          const TimeButtonSelector(),
        ],
      ),
    );
  }
}

class ClickableDayName extends StatelessWidget {
  const ClickableDayName({super.key});

  void _showDayPicker(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<WelcomeScreenCubit>();
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    final options = [
      {
        'index': 0,
        'dayName': _getDayName(yesterday),
        'label': 'Hier',
        'date': yesterday,
      },
      {
        'index': 1,
        'dayName': _getDayName(now),
        'label': 'Aujourd\'hui',
        'date': now,
      },
      {
        'index': 2,
        'dayName': _getDayName(tomorrow),
        'label': 'Demain',
        'date': tomorrow,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Sélectionner un jour',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            ...options.map((option) {
              final isSelected = cubit.state.selectedDayIndex == option['index'];
              return InkWell(
                onTap: () {
                  cubit.updateSelectedDay(option['index'] as int);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: option['dayName'] as String,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? theme.colorScheme.primary : Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: ' (${option['label']})',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isSelected ? theme.colorScheme.primary.withOpacity(0.7) : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                          size: 20.sp,
                        ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 16.h + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  String _getDayName(DateTime date) {
    final days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeScreenCubit, WelcomeScreenState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _showDayPicker(context),
          child: Row(
            children: [
              Text(
                context.read<WelcomeScreenCubit>().getSelectedDayName(),
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down,
                size: 24.sp,
                color: Colors.grey[600],
              ),
            ],
          ),
        );
      },
    );
  }
}

class TimeButtonSelector extends StatelessWidget {
  const TimeButtonSelector({super.key});

  final List<Map<String, dynamic>> _timeButtons = const [
    {'label': 'Matin', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Après-midi', 'icon': Icons.wb_sunny},
    {'label': 'Soir', 'icon': Icons.wb_twilight},
    {'label': 'Nuit', 'icon': Icons.nightlight_round},
  ];

  void _onTap(BuildContext context, int index) {
    final cubit = context.read<WelcomeScreenCubit>();
    final currentSelected = cubit.state.selectedTimeIndex;
    cubit.updateSelectedTime(currentSelected == index ? -1 : index);
  }

  Widget _btn(String label, IconData icon, bool selected, VoidCallback tap, ThemeData theme) {
    return GestureDetector(
      onTap: tap,
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: selected ? theme.colorScheme.primary : Colors.grey[200],
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              color: selected ? Colors.white : Colors.grey[600],
              size: 28.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: selected ? theme.colorScheme.primary : Colors.grey[600],
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<WelcomeScreenCubit, WelcomeScreenState>(
      builder: (context, state) {
        final selectedIndex = state.selectedTimeIndex;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_timeButtons.length, (i) {
            final button = _timeButtons[i];
            return _btn(
              button['label'],
              button['icon'],
              i == selectedIndex,
                  () => _onTap(context, i),
              theme,
            );
          }),
        );
      },
    );
  }
}

class MedicationScheduleCard extends StatelessWidget {
  const MedicationScheduleCard({super.key});

  Widget _timeHeader(String time, ThemeData theme) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: theme.colorScheme.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2), width: 1.w),
    ),
    child: Text(
      time,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    ),
  );

  Widget _divider(ThemeData theme) => Divider(
    color: theme.colorScheme.primary.withOpacity(0.25),
    height: 0,
    thickness: 1.h,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<WelcomeScreenCubit, WelcomeScreenState>(
      builder: (context, state) {
        if (!state.hasReminders) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medication_outlined,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Aucun rappel disponible',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Profitez de votre journée!',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        final remindersToShow = context.read<WelcomeScreenCubit>().getRemindersForSelectedTimeSlot();

        if (remindersToShow.isEmpty) {
          final dayName = state.selectedDayIndex == 1
              ? 'aujourd\'hui'
              : state.selectedDayIndex == 0
              ? 'hier'
              : 'demain';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Aucun rappel pour $dayName',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (state.selectedTimeIndex != -1) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'Essayez une autre période',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        final groupedByTime = <String, List<ReminderEntity>>{};
        for (final reminder in remindersToShow) {
          final timeKey = reminder.timeString;
          if (!groupedByTime.containsKey(timeKey)) {
            groupedByTime[timeKey] = [];
          }
          groupedByTime[timeKey]!.add(reminder);
        }

        return RefreshIndicator(
          onRefresh: () => context.read<WelcomeScreenCubit>().fetchReminders(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              children: groupedByTime.entries.map((entry) {
                final time = entry.key;
                final timeReminders = entry.value;

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _timeHeader(time, theme),
                          SizedBox(height: 18.h),
                          ...timeReminders.map((reminder) => Column(
                            children: [
                              ReminderTile(reminder: reminder),
                              if (reminder != timeReminders.last) SizedBox(height: 12.h),
                            ],
                          )),
                        ],
                      ),
                    ),
                    if (entry.key != groupedByTime.keys.last) _divider(theme),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class ReminderTile extends StatelessWidget {
  const ReminderTile({super.key, required this.reminder});

  final ReminderEntity reminder;

  Color _getMedicationColor(String medicationName) {
    final hash = medicationName.hashCode;
    final colors = [
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.green,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[hash.abs() % colors.length];
  }

  IconData _getMedicationIcon(String medicationName) {
    final hash = medicationName.hashCode;
    final icons = [
      Icons.medication,
      Icons.local_hospital,
      Icons.medication_liquid,
      Icons.healing,
      Icons.vaccines,
    ];
    return icons[hash.abs() % icons.length];
  }

  bool _canInteract() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final reminderDate = DateTime(
      reminder.reminderTime.year,
      reminder.reminderTime.month,
      reminder.reminderTime.day,
    );

    return reminderDate.isAtSameMomentAs(today) ||
        reminderDate.isAtSameMomentAs(yesterday);
  }

  bool _isYesterday() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    final reminderDate = DateTime(
      reminder.reminderTime.year,
      reminder.reminderTime.month,
      reminder.reminderTime.day,
    );
    return reminderDate.isAtSameMomentAs(yesterday);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WelcomeScreenCubit>();
    final isOverdue = reminder.isOverdue;
    final isDue = reminder.isDue;
    final isTaken = reminder.isTaken;
    final isScheduled = reminder.isScheduled;
    final canInteract = _canInteract();
    final isYesterday = _isYesterday();

    final color = _getMedicationColor(reminder.medicationName);
    final icon = _getMedicationIcon(reminder.medicationName);

    // Already taken - show taken card
    if (isTaken) {
      return MedicationTakenTile(
        name: reminder.medicationName,
        description: reminder.message,
        color: color,
        icon: icon,
        takenTime: reminder.timeString,
        prescriptionName: reminder.prescriptionName,
      );
    }

    // Missed and cron job already changed to MISSED (after 2 days)
    if (reminder.status.toUpperCase() == 'MISSED') {
      return MedicationNotTakenTile(
        name: reminder.medicationName,
        description: reminder.message,
        color: color,
        icon: icon,
        prescriptionName: reminder.prescriptionName,
        isOverdue: true,
        status: 'Manqué',
        canInteract: false,
      );
    }

    // Can interact ONLY if:
    // 1. It's time to take it (isDue) OR it's overdue from today OR it's from yesterday
    // 2. AND it's still scheduled
    if (canInteract && isScheduled) {
      // Show interactive card only when:
      // - It's due now (within 30 minutes) OR
      // - It's overdue from today OR
      // - It's from yesterday (missed yesterday)
      if (isDue || (isOverdue && !isYesterday) || isYesterday) {
        return MedicationDueTile(
          name: reminder.medicationName,
          description: reminder.message,
          color: color,
          icon: icon,
          prescriptionName: reminder.prescriptionName,
          onTaken: () => cubit.markMedicationAsTaken(reminder.id),
          onRemindLater: () => cubit.snoozeReminder(reminder.id),
          isOverdue: isOverdue,
          isYesterday: isYesterday,
        );
      }
    }

    // Default case - show read-only card for scheduled but not yet time
    return MedicationNotTakenTile(
      name: reminder.medicationName,
      description: reminder.message,
      color: color,
      icon: icon,
      prescriptionName: reminder.prescriptionName,
      isOverdue: false, // Not overdue if it's just scheduled for later
      status: _getDisplayStatus(),
      canInteract: false, // No interaction until it's time
    );
  }

  /// Get appropriate display status based on timing
  String _getDisplayStatus() {
    final now = DateTime.now();

    if (reminder.reminderTime.isAfter(now)) {
      // Future reminder - show when it's scheduled
      return 'Prévu à ${reminder.timeString}';
    }

    return reminder.status; // Default to actual status
  }
}

class MedicationTakenTile extends StatelessWidget {
  const MedicationTakenTile({
    super.key,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.prescriptionName,
    this.takenTime,
  });

  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final String prescriptionName;
  final String? takenTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _tickBox(theme),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: _detailDecoration(),
              child: Row(
                children: [
                  _leadingIcon(),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          takenTime != null
                              ? 'Médicament pris à $takenTime'
                              : 'Médicament pris',
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          prescriptionName,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tickBox(ThemeData theme) {
    const double baseRaw = 64;
    return Container(
      width: baseRaw.w,
      constraints: BoxConstraints(minHeight: baseRaw.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular((baseRaw * 0.25).r),
      ),
      child: Center(
        child: Container(
          width: (baseRaw * 0.60).r,
          height: (baseRaw * 0.60).r,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.35),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Icon(Icons.check, color: Colors.white, size: 24.sp),
        ),
      ),
    );
  }

  Widget _leadingIcon() => Container(
    width: 40.w,
    height: 40.w,
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Icon(icon, color: color, size: 22.sp),
  );

  BoxDecoration _detailDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14.r),
  );
}

class MedicationDueTile extends StatelessWidget {
  const MedicationDueTile({
    super.key,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.prescriptionName,
    required this.onTaken,
    required this.onRemindLater,
    this.isOverdue = false,
    this.isYesterday = false,
  });

  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final String prescriptionName;
  final VoidCallback onTaken;
  final VoidCallback onRemindLater;
  final bool isOverdue;
  final bool isYesterday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _boxDecoration(theme),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _leadingIcon(),
              SizedBox(width: 14.w),
              Expanded(child: _texts()),
              _urgencyIndicator(theme),
            ],
          ),
          if (isOverdue || isYesterday) ...[
            SizedBox(height: 12.h),
            _badge(
              isYesterday
                  ? 'Médicament d\'hier non pris'
                  : 'Médicament en retard!',
              isYesterday ? Colors.orange : Colors.red,
              Icons.warning,
            ),
          ],
          SizedBox(height: 14.h),
          Row(
            children: [
              if (!isYesterday) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRemindLater,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
                      minimumSize: Size(0, 38.h),
                      shape: const StadiumBorder(),
                      side: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.55),
                        width: 1.w,
                      ),
                    ),
                    child: Text(
                      'Rappeler plus tard',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: onTaken,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
                    minimumSize: Size(0, 38.h),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    isYesterday ? 'Marquer comme pris' : 'Pris',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _leadingIcon() => Container(
    width: 40.w,
    height: 40.w,
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Icon(icon, color: color, size: 22.sp),
  );

  Widget _texts() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 4.h),
      Text(
        description,
        style: TextStyle(fontSize: 12.5.sp, color: Colors.grey[600]),
      ),
      SizedBox(height: 2.h),
      Text(
        prescriptionName,
        style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
      ),
    ],
  );

  Widget _urgencyIndicator(ThemeData theme) => Container(
    padding: EdgeInsets.all(6.w),
    decoration: BoxDecoration(
      color: (isOverdue || isYesterday)
          ? (isYesterday ? Colors.orange.withOpacity(0.1) : Colors.red.withOpacity(0.1))
          : Colors.orange.withOpacity(0.1),
      shape: BoxShape.circle,
    ),
    child: Icon(
      (isOverdue || isYesterday) ? Icons.warning : Icons.schedule,
      color: (isOverdue || isYesterday)
          ? (isYesterday ? Colors.orange : Colors.red)
          : Colors.orange,
      size: 16.sp,
    ),
  );

  Widget _badge(String msg, Color c, IconData iconData) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
    decoration: BoxDecoration(
      color: c.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: c.withOpacity(0.35), width: 1.w),
    ),
    child: Row(
      children: [
        Icon(iconData, color: c, size: 18.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            msg,
            style: TextStyle(
              fontSize: 12.sp,
              color: c,
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
          ),
        ),
      ],
    ),
  );

  BoxDecoration _boxDecoration(ThemeData theme) => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14.r),
  );
}

class MedicationNotTakenTile extends StatelessWidget {
  const MedicationNotTakenTile({
    super.key,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.prescriptionName,
    required this.isOverdue,
    required this.status,
    this.canInteract = false,
  });

  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final String prescriptionName;
  final bool isOverdue;
  final String status;
  final bool canInteract;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              _leadingIcon(),
              SizedBox(width: 14.w),
              Expanded(child: _texts()),
              _statusIndicator(theme),
            ],
          ),
          if (isOverdue) ...[
            SizedBox(height: 12.h),
            _badge(
              status.toUpperCase() == 'MISSED'
                  ? 'Médicament manqué (automatique)'
                  : 'Médicament en retard',
              status.toUpperCase() == 'MISSED'
                  ? Colors.grey.shade600
                  : Colors.red,
              Icons.warning,
            ),
          ],
        ],
      ),
    );
  }

  Widget _leadingIcon() => Container(
    width: 40.w,
    height: 40.w,
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Icon(icon, color: color, size: 22.sp),
  );

  Widget _texts() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 4.h),
      Text(
        description,
        style: TextStyle(fontSize: 12.5.sp, color: Colors.grey[600]),
      ),
      SizedBox(height: 2.h),
      Text(
        prescriptionName,
        style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
      ),
    ],
  );

  Widget _statusIndicator(ThemeData theme) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: status.toUpperCase() == 'MISSED'
          ? Colors.grey.shade200
          : theme.colorScheme.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Text(
      status.toUpperCase() == 'MISSED' ? 'Manqué' : status,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: status.toUpperCase() == 'MISSED'
            ? Colors.grey.shade600
            : theme.colorScheme.primary,
      ),
    ),
  );

  Widget _badge(String msg, Color c, IconData iconData) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: c.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: c.withOpacity(0.35), width: 1.w),
    ),
    child: Row(
      children: [
        Icon(iconData, color: c, size: 18.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            msg,
            style: TextStyle(
              fontSize: 12.5.sp,
              color: c,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14.r),
  );
}