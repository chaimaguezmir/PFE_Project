import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/presentation/bloc/home/welcome_screen_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';

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
      body: Column(
        children: [
          // Day selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mardi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    TimeButtonSelector(),

                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Medication Schedule Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.blue.withOpacity(0.12),
                  width: 1,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 8:00 Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blue.withOpacity(0.3),
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              '8:00',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Omega 3
                          _buildScheduleMedicationItem(
                            'Omega 3',
                            '1 tablet after meals',
                            '7 Jours',
                            Colors.orange,
                            Icons.medication,
                            progress: 0.51, // 51% overall treatment progress
                            isTakenToday: false,
                          ),

                          const SizedBox(height: 16),

                          // Comlivit
                          _buildScheduleMedicationItem(
                            'Comlivit',
                            '1 tablet after meals',
                            '7 Jours',
                            Colors.grey,
                            Icons.medication,
                            progress: 0.7, // 70% overall treatment progress
                            isTakenToday: true,
                            takenTime: '12h30',
                          ),
                        ],
                      ),
                    ),

                    // 14:00 Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              '14:00',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 5-HTP
                          _buildScheduleMedicationItem(
                            '5-HTP',
                            '1 ampoule',
                            '2 Jours',
                            Colors.teal,
                            Icons.water_drop,
                            progress: 0.0, // 0% overall treatment progress
                            isTakenToday: false,
                          ),

                          const SizedBox(height: 12),

                          // Warning message
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.2),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 16),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'You have two ampoules left',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Comlivit (second)
                          _buildScheduleMedicationItem(
                            'Comlivit',
                            '1 tablet',
                            '7 Jours',
                            Colors.brown,
                            Icons.medication,
                            progress: 0.3, // 30% overall treatment progress
                            isTakenToday: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String label, IconData icon, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey[600],
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.blue : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }


  Widget _buildScheduleMedicationItem(
      String name,
      String description,
      String duration,
      Color color,
      IconData icon, {
        double progress = 0.0, // 0.0 to 1.0 (overall treatment progress)
        bool isTakenToday = false, // taken today or not
        String? takenTime, // time when taken today
      }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTakenToday ? Colors.blue.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTakenToday
              ? Colors.blue.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Medication icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),

          // Medication info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isTakenToday && takenTime != null
                      ? 'Médicament pris à $takenTime'
                      : description,
                  style: TextStyle(
                    fontSize: 11,
                    color: isTakenToday ? Colors.green[600] : Colors.grey[600],
                    fontWeight: isTakenToday
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

          // Right side: Overall treatment progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                child: Stack(
                  children: [
                    // Background circle
                    Container(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ),
                    // Progress circle
                    Container(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                      ),
                    ),
                    // Progress percentage text
                    Container(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: progress > 0 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                duration,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class TimeButtonSelector extends StatelessWidget {
  const TimeButtonSelector({super.key});

  final List<Map<String, dynamic>> timeButtons = const [
    {
      'label': 'Matin',
      'icon': Icons.wb_sunny_outlined,
    },
    {
      'label': 'Après Midi',
      'icon': Icons.wb_sunny,
    },
    {
      'label': 'Soir',
      'icon': Icons.wb_twilight,
    },
    {
      'label': 'Nuit',
      'icon': Icons.nightlight_round,
    },
  ];

  void onTimeButtonTap(BuildContext context, int index) {
    context.read<WelcomeScreenCubit>().updateSelectedTime(index);
  }

  Widget _buildTimeButton(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(

        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.blue : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
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
        int selectedIndex = state.selectedTimeIndex;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(timeButtons.length, (index) {
            var button = timeButtons[index];
            return _buildTimeButton(
              button['label'],
              button['icon'],
              index == selectedIndex,
                  () => onTimeButtonTap(context, index),
            );
          }),
        );
      },
    );
  }
}