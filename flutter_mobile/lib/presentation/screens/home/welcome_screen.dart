// lib/presentation/screens/home/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/presentation/bloc/home/welcome_screen_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Accueil",
        username: "Walid Zaroui",
        email: "zarwi.walid@gmail.com",
        avatarPath: "lib/config/assets/images/default_avatar.jpg",
        showLeading: true,
      ),
      backgroundColor: Colors.grey[50],
      body: const Column(
        children: [
          _DayHeader(),
          Expanded(child: MedicationScheduleCard()),
        ],
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
          Text('Mardi',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 18.h),
          const TimeButtonSelector(),
        ],
      ),
    );
  }
}

class TimeButtonSelector extends StatelessWidget {
  const TimeButtonSelector({super.key});

  final List<Map<String, dynamic>> _timeButtons = const [
    {'label': 'Matin', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Après Midi', 'icon': Icons.wb_sunny},
    {'label': 'Soir', 'icon': Icons.wb_twilight},
    {'label': 'Nuit', 'icon': Icons.nightlight_round},
  ];

  void _onTap(BuildContext context, int index) {
    final cubit = context.read<WelcomeScreenCubit>();
    final sel = cubit.state.selectedTimeIndex;
    cubit.updateSelectedTime(sel == index ? -1 : index);
  }

  Widget _btn(String label, IconData icon, bool selected, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: selected ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon,
                color: selected ? Colors.white : Colors.grey[600],
                size: 28.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: selected ? Colors.blue : Colors.grey[600],
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeScreenCubit, WelcomeScreenState>(
      builder: (context, state) {
        final sel = state.selectedTimeIndex;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_timeButtons.length, (i) {
            final b = _timeButtons[i];
            return _btn(
              b['label'],
              b['icon'],
              i == sel && sel != -1,
                  () => _onTap(context, i),
            );
          }),
        );
      },
    );
  }
}

class MedicationScheduleCard extends StatelessWidget {
  const MedicationScheduleCard({super.key});

  Widget _timeHeader(String t) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1.w),
    ),
    child: Text(
      t,
      style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.blue),
    ),
  );

  Widget _divider() =>
      Divider(color: Colors.blue.withOpacity(0.25), height: 0, thickness: 1.h);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _timeHeader('8:00'),
                SizedBox(height: 18.h),
                const MedicationScheduleItem(
                  name: 'Omega 3',
                  description: '1 tablet after meals',
                  duration: '7 Jours',
                  color: Colors.orange,
                  icon: Icons.medication,
                  progress: 0.51,
                  isTakenToday: false,
                ),
                SizedBox(height: 18.h),
                const MedicationScheduleItem(
                  name: 'Vit D',
                  description: '1 capsule',
                  duration: '14 Jours',
                  color: Colors.deepOrange,
                  icon: Icons.local_hospital,
                  progress: 0.2,
                  isTakenToday: false,
                ),
              ],
            ),
          ),
          _divider(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _timeHeader('14:00'),
                SizedBox(height: 18.h),
                const MedicationScheduleItem(
                  name: 'Comlivit',
                  description: '1 tablet after meals',
                  duration: '7 Jours',
                  color: Colors.grey,
                  icon: Icons.medication,
                  warningMessage: 'medicament non pris',
                  progress: 0.7,
                  isTakenToday: false,
                ),
                SizedBox(height: 18.h),
                const MedicationScheduleItem(
                  name: 'Omega 3',
                  description: '1 tablet after meals',
                  duration: '7 Jours',
                  color: Colors.orange,
                  icon: Icons.medication,
                  isTakenToday: true,
                  takenTime: '12h30',
                ),
                SizedBox(height: 18.h),
                const MedicationScheduleItem(
                  name: 'Paracétamol',
                  description: '500 mg après repas',
                  duration: '5 Jours',
                  color: Colors.teal,
                  icon: Icons.medication_liquid,
                  progress: 0.35,
                  isDue: true,            // <-- shows the due tile with buttons
                  isTakenToday: false,
warningMessage: 'medicament non pris',
                  onTaken: null,          // will default to empty if null (or supply a function)
                  onRemindLater: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MedicationScheduleItem extends StatelessWidget {
  const MedicationScheduleItem({
    super.key,
    required this.name,
    required this.description,
    required this.duration,
    required this.color,
    required this.icon,
    this.progress = 0.0,
    this.isTakenToday = false,
    this.isDue = false,
    this.takenTime,
    this.warningMessage,
    this.alertMessage,
    this.onTaken,
    this.onRemindLater,
  });

  final String name;
  final String description;
  final String duration;
  final Color color;
  final IconData icon;
  final double progress;
  final bool isTakenToday;
  final bool isDue;
  final String? takenTime;
  final String? warningMessage;
  final String? alertMessage;
  final VoidCallback? onTaken;
  final VoidCallback? onRemindLater;

  @override
  Widget build(BuildContext context) {
    if (isTakenToday) {
      return MedicationTakenTile(
        name: name,
        description: description,
        color: color,
        icon: icon,
        takenTime: takenTime,
        warningMessage: warningMessage,
        alertMessage: alertMessage,
      );
    }
    if (isDue) {
      return MedicationDueTile(
        name: name,
        description: description,
        duration: duration,
        color: color,
        icon: icon,
        progress: progress,
        warningMessage: warningMessage,
        alertMessage: alertMessage,
        onTaken: onTaken ?? () {},
        onRemindLater: onRemindLater ?? () {},
      );
    }
    return MedicationNotTakenTile(
      name: name,
      description: description,
      duration: duration,
      color: color,
      icon: icon,
      progress: progress,
      warningMessage: warningMessage,
      alertMessage: alertMessage,
    );
  }
}

class MedicationNotTakenTile extends StatelessWidget {
  const MedicationNotTakenTile({
    super.key,
    required this.name,
    required this.description,
    required this.duration,
    required this.color,
    required this.icon,
    this.progress = 0.0,
    this.warningMessage,
    this.alertMessage,
  });

  final String name;
  final String description;
  final String duration;
  final Color color;
  final IconData icon;
  final double progress;
  final String? warningMessage;
  final String? alertMessage;

  @override
  Widget build(BuildContext context) {
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
              _progressColumn(),
            ],
          ),
          if (alertMessage != null) ...[
            SizedBox(height: 12.h),
            _badge(alertMessage!, Colors.red, Icons.error),
          ],
          if (warningMessage != null) ...[
            SizedBox(height: 12.h),
            _badge(warningMessage!, Colors.orange, Icons.error),
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
      Text(name,
          style:
          TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
      SizedBox(height: 4.h),
      Text(description,
          style:
          TextStyle(fontSize: 12.5.sp, color: Colors.grey[600])),
    ],
  );

  Widget _progressColumn() => Column(
    children: [
      SizedBox(
        width: 56.w,
        height: 56.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: 1,
              strokeWidth: 4.w,
              valueColor:
              AlwaysStoppedAnimation(Colors.grey.withOpacity(0.18)),
              backgroundColor: Colors.transparent,
            ),
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 4.w,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              backgroundColor: Colors.transparent,
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: progress > 0 ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 8.h),
      Text(
        duration,
        style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500),
      ),
    ],
  );

  Widget _badge(String msg, Color c, IconData icon) => Container(
    width: double.infinity,
    padding:
    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: c.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: c.withOpacity(0.35), width: 1.w),
    ),
    child: Row(
      children: [
        Icon(icon, color: c, size: 18.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            msg,
            style: TextStyle(
                fontSize: 12.5.sp,
                color: c,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14.r),
    border: Border.all(color: Colors.grey.withOpacity(0.18), width: 1.w),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10.r,
        offset: Offset(0, 3.h),
      ),
    ],
  );
}

class MedicationTakenTile extends StatelessWidget {
  const MedicationTakenTile({
    super.key,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    this.takenTime,
    this.warningMessage,
    this.alertMessage,
  });

  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final String? takenTime;
  final String? warningMessage;
  final String? alertMessage;

  @override
  Widget build(BuildContext context) {
    final desc =
    takenTime != null ? 'Médicament pris à $takenTime' : description;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _tickBox(),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: _detailDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _leadingIcon(),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 4.h),
                            Text(
                              desc,
                              style: TextStyle(
                                  fontSize: 12.5.sp,
                                  color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (alertMessage != null) ...[
                    SizedBox(height: 14.h),
                    _badge(alertMessage!, Colors.red, Icons.error),
                  ],
                  if (warningMessage != null) ...[
                    SizedBox(height: 14.h),
                    _badge(warningMessage!, Colors.orange,
                        Icons.warning_amber_rounded),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tickBox() {
    const double baseRaw = 64;
    return Container(
      width: baseRaw.w,
      constraints: BoxConstraints(minHeight: baseRaw.h),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.5),
        borderRadius: BorderRadius.circular((baseRaw * 0.25).r),
      ),
      child: Center(
        child: Container(
          width: (baseRaw * 0.60).r,
          height: (baseRaw * 0.60).r,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.35),
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

  Widget _badge(String msg, Color c, IconData icon) => Container(
    width: double.infinity,
    padding:
    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: c.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: c.withOpacity(0.35), width: 1.w),
    ),
    child: Row(
      children: [
        Icon(icon, color: c, size: 20.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            msg,
            style: TextStyle(
                fontSize: 12.5.sp,
                color: c,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  BoxDecoration _detailDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14.r),
    border: Border.all(color: Colors.grey.withOpacity(0.18), width: 1.w),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10.r,
        offset: Offset(0, 3.h),
      ),
    ],
  );
}

// dart
class MedicationDueTile extends StatelessWidget {
  const MedicationDueTile({
    super.key,
    required this.name,
    required this.description,
    required this.duration, // retained but not shown
    required this.color,
    required this.icon,
    required this.progress, // retained but not shown
    required this.onTaken,
    required this.onRemindLater,
    this.warningMessage,
    this.alertMessage,
  });

  final String name;
  final String description;
  final String duration; // no longer displayed
  final Color color;
  final IconData icon;
  final double progress; // no longer displayed
  final String? warningMessage;
  final String? alertMessage;
  final VoidCallback onTaken;
  final VoidCallback onRemindLater;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _leadingIcon(),
              SizedBox(width: 14.w),
              Expanded(child: _texts()),
            ],
          ),
          if (alertMessage != null) ...[
            SizedBox(height: 12.h),
            _badge(alertMessage!, Colors.red, Icons.error),
          ],
          if (warningMessage != null) ...[
            SizedBox(height: 12.h),
            _badge(warningMessage!, Colors.orange, Icons.warning_amber_rounded),
          ],
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onRemindLater,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
                    minimumSize: Size(0, 38.h),
                    shape: const StadiumBorder(),
                    side: BorderSide(
                      color: Colors.blue.withOpacity(0.55),
                      width: 1.w,
                    ),
                  ),
                  child: Text(
                    'Rappeler plus tard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onTaken,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
                    minimumSize: Size(0, 38.h),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Pris',
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
    ],
  );

  Widget _badge(String msg, Color c, IconData icon) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
    decoration: BoxDecoration(
      color: c.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: c.withOpacity(0.35), width: 1.w),
    ),
    child: Row(
      children: [
        Icon(icon, color: c, size: 18.sp),
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

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14.r),
    border: Border.all(color: Colors.grey.withOpacity(0.18), width: 1.w),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10.r,
        offset: Offset(0, 3.h),
      ),
    ],
  );
}