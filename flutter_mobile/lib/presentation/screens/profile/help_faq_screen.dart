import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Help & FAQ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            _buildFaqSection(
              'Getting Started',
              [
                _FaqItem(
                  question: 'How do I create an account?',
                  answer:
                      'To create an account, tap on "Sign Up" on the welcome screen, enter your details (name, email, password), and verify your email address with the OTP code sent to your inbox.',
                ),
                _FaqItem(
                  question: 'How do I join a group?',
                  answer:
                      'You can join a group by asking a group manager or responsible person to share the group invite code with you. Then, go to the Groups section and tap "Join Group" to enter the code.',
                ),
                _FaqItem(
                  question: 'What is a Pharmacy Box?',
                  answer:
                      'A Pharmacy Box is a virtual container where you store and manage your medicines. Each group can have multiple pharmacy boxes to organize medicines for different family members or purposes.',
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildFaqSection(
              'Managing Medicines',
              [
                _FaqItem(
                  question: 'How do I add a medicine?',
                  answer:
                      'Go to your Pharmacy Box, tap the "+" button, then either scan the barcode on the medicine package or manually search for the medicine name. Enter the quantity, expiry date, and other details.',
                ),
                _FaqItem(
                  question: 'How do I set up medication reminders?',
                  answer:
                      'Open a medicine from your Pharmacy Box, tap "Set Reminder", choose the time and frequency (daily, weekly, etc.), and save. You will receive notifications at the scheduled times.',
                ),
                _FaqItem(
                  question: 'Can I track medicine consumption?',
                  answer:
                      'Yes! Each time you take a medicine, mark it in the app. The system automatically tracks your consumption history and updates the remaining quantity in your pharmacy box.',
                ),
                _FaqItem(
                  question: 'What happens when a medicine expires?',
                  answer:
                      'The app will notify you when a medicine is approaching its expiry date. You can then update the inventory or remove the expired medicine from your pharmacy box.',
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildFaqSection(
              'Groups & Collaboration',
              [
                _FaqItem(
                  question: 'What are group roles?',
                  answer:
                      'There are three roles: MANAGER (full control, can add/remove members), RESPONSIBLE (can manage medicines and prescriptions), and MEMBER (can view and use medicines).',
                ),
                _FaqItem(
                  question: 'Can I manage medicines for family members?',
                  answer:
                      'Yes! If you have MANAGER or RESPONSIBLE role, you can add family members to the group and manage their medicines, prescriptions, and reminders.',
                ),
                _FaqItem(
                  question: 'How do I share my group with others?',
                  answer:
                      'As a group manager, go to Group Settings, tap "Invite Members", and share the generated invite code with the people you want to add to your group.',
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildFaqSection(
              'Prescriptions & Treatments',
              [
                _FaqItem(
                  question: 'How do I add a prescription?',
                  answer:
                      'Go to the Prescriptions section, tap "Add Prescription", enter the doctor details, diagnosis, and prescribed medicines. You can also upload a photo of the prescription.',
                ),
                _FaqItem(
                  question: 'Can I track my treatment progress?',
                  answer:
                      'Yes! The Treatments section allows you to track ongoing treatments, view medication schedules, and monitor your progress over time.',
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildFaqSection(
              'Account & Security',
              [
                _FaqItem(
                  question: 'How do I reset my password?',
                  answer:
                      'On the login screen, tap "Forgot Password", enter your email address, and you will receive a reset code. Enter the code and set a new password.',
                ),
                _FaqItem(
                  question: 'Is my medical data secure?',
                  answer:
                      'Yes! We use industry-standard encryption and security measures to protect your data. Your information is only accessible to you and authorized group members.',
                ),
                _FaqItem(
                  question: 'How do I update my profile?',
                  answer:
                      'Go to the Profile tab, tap on your profile picture or name, and you can update your name, email, phone number, and profile photo.',
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Center(
              child: Column(
                children: [
                  Text(
                    'Still need help?',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(AppRouteName.contactSupport);
                    },
                    child: Text(
                      'Contact Support',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection(String title, List<_FaqItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        ...items.map((item) => _buildFaqTile(item)),
      ],
    );
  }

  Widget _buildFaqTile(_FaqItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        title: Text(
          item.question,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        children: [
          Text(
            item.answer,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  _FaqItem({
    required this.question,
    required this.answer,
  });
}
