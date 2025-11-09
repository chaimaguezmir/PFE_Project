import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

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
              'Legal',
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
            // Legal Options
            _buildLegalCard(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServiceScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            _buildLegalCard(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            _buildLegalCard(
              icon: Icons.article_outlined,
              title: 'Licenses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LicensesScreen(),
                  ),
                );
              },
            ),

            SizedBox(height: 32.h),

            // App Information
            Center(
              child: Column(
                children: [
                  Text(
                    'Afya Medicine Management',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Version 0.0.1',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '© 2025 Afya. All rights reserved.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: secondaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Terms of Service Screen
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
              'Terms of Service',
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
              'Last Updated: November 4, 2025',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 24.h),

            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using Afya Medicine Management ("the App"), you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use the App.',
            ),
            _buildSection(
              '2. Use License',
              'Permission is granted to temporarily use the App for personal, non-commercial purposes. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose\n• Attempt to decompile or reverse engineer any software contained in the App\n• Remove any copyright or other proprietary notations from the materials',
            ),
            _buildSection(
              '3. Medical Disclaimer',
              'The App is designed to help you manage your medicines and health information. However, it is NOT a substitute for professional medical advice, diagnosis, or treatment.\n\nAlways seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition. Never disregard professional medical advice or delay in seeking it because of something you have read or accessed through the App.',
            ),
            _buildSection(
              '4. User Responsibilities',
              'You are responsible for:\n\n• Maintaining the confidentiality of your account credentials\n• All activities that occur under your account\n• Ensuring that all information you provide is accurate and up-to-date\n• Verifying medicine information and expiry dates\n• Following prescribed medication schedules as directed by your healthcare provider',
            ),
            _buildSection(
              '5. Data Accuracy',
              'While we strive to provide accurate medicine information, we do not guarantee the completeness, reliability, or accuracy of this information. You should always verify medicine details with your healthcare provider or pharmacist.',
            ),
            _buildSection(
              '6. Privacy',
              'Your use of the App is also governed by our Privacy Policy. Please review our Privacy Policy, which also governs the App and informs users of our data collection practices.',
            ),
            _buildSection(
              '7. Group Sharing',
              'When you join or create a group, you acknowledge that:\n\n• Group members with appropriate roles may view and manage shared medicine information\n• You are responsible for the security of your group invite codes\n• Group managers have the authority to add or remove members\n• You should only share groups with trusted individuals',
            ),
            _buildSection(
              '8. Modifications',
              'We reserve the right to modify these terms at any time. We will notify users of any material changes. Your continued use of the App after such modifications will constitute acknowledgment and agreement of the modified terms.',
            ),
            _buildSection(
              '9. Termination',
              'We may terminate or suspend your account and access to the App immediately, without prior notice or liability, for any reason, including if you breach these Terms of Service.',
            ),
            _buildSection(
              '10. Limitation of Liability',
              'In no event shall Afya or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the App.',
            ),
            _buildSection(
              '11. Contact Information',
              'For questions about these Terms of Service, please contact us at:\n\nEmail: support@afya.com\nPhone: +212 612 345 678',
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
              'Privacy Policy',
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
              'Last Updated: November 4, 2025',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 24.h),

            _buildSection(
              'Introduction',
              'Afya Medicine Management ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),
            _buildSection(
              'Information We Collect',
              'We collect information that you provide directly to us, including:\n\n• Account Information: Name, email address, phone number, password\n• Profile Information: Profile picture, date of birth\n• Health Information: Medicine names, dosages, prescriptions, treatment plans, medical conditions\n• Group Information: Group memberships, roles, and shared data\n• Device Information: Device type, operating system, unique device identifiers\n• Usage Information: How you interact with the App, features used, time spent',
            ),
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to:\n\n• Provide, maintain, and improve our services\n• Process your requests and transactions\n• Send you medication reminders and notifications\n• Communicate with you about updates, security alerts, and support\n• Monitor and analyze trends, usage, and activities\n• Detect, prevent, and address technical issues and fraudulent activity\n• Personalize your experience in the App',
            ),
            _buildSection(
              'Data Sharing and Disclosure',
              'We may share your information in the following situations:\n\n• With Group Members: Information you add to shared pharmacy boxes is visible to other group members with appropriate permissions\n• Service Providers: We may share data with third-party service providers who perform services on our behalf\n• Legal Requirements: We may disclose information if required by law or in response to valid requests by public authorities\n• Business Transfers: In connection with any merger, sale of company assets, or acquisition',
            ),
            _buildSection(
              'Data Security',
              'We implement appropriate technical and organizational measures to protect your personal information, including:\n\n• Encryption of data in transit and at rest\n• Secure authentication using JWT tokens\n• Regular security assessments\n• Access controls and authorization mechanisms\n• Secure cloud infrastructure\n\nHowever, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
            ),
            _buildSection(
              'Data Retention',
              'We retain your personal information for as long as necessary to:\n\n• Provide you with our services\n• Comply with legal obligations\n• Resolve disputes\n• Enforce our agreements\n\nYou may request deletion of your account and associated data at any time.',
            ),
            _buildSection(
              'Your Rights',
              'Depending on your location, you may have the following rights:\n\n• Access: Request access to your personal information\n• Correction: Request correction of inaccurate data\n• Deletion: Request deletion of your data\n• Portability: Request a copy of your data in a structured format\n• Objection: Object to processing of your data\n• Withdrawal: Withdraw consent at any time\n\nTo exercise these rights, please contact us at support@afya.com.',
            ),
            _buildSection(
              'Children\'s Privacy',
              'Our App is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If you become aware that a child has provided us with personal information, please contact us.',
            ),
            _buildSection(
              'International Data Transfers',
              'Your information may be transferred to and processed in countries other than your country of residence. These countries may have different data protection laws. We take appropriate safeguards to ensure your data remains protected.',
            ),
            _buildSection(
              'Changes to This Privacy Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the App and updating the "Last Updated" date. You are advised to review this Privacy Policy periodically.',
            ),
            _buildSection(
              'Contact Us',
              'If you have questions or concerns about this Privacy Policy, please contact us:\n\nEmail: support@afya.com\nPhone: +212 612 345 678\nAddress: Morocco',
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Licenses Screen
class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});

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
              'Open Source Licenses',
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
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Text(
            'This application uses the following open source packages:',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          _buildLicenseCard(
            'Flutter',
            'BSD-3-Clause License',
            'https://flutter.dev',
          ),
          _buildLicenseCard(
            'flutter_bloc',
            'MIT License',
            'https://pub.dev/packages/flutter_bloc',
          ),
          _buildLicenseCard(
            'dio',
            'MIT License',
            'https://pub.dev/packages/dio',
          ),
          _buildLicenseCard(
            'get_it',
            'MIT License',
            'https://pub.dev/packages/get_it',
          ),
          _buildLicenseCard(
            'go_router',
            'BSD-3-Clause License',
            'https://pub.dev/packages/go_router',
          ),
          _buildLicenseCard(
            'shared_preferences',
            'BSD-3-Clause License',
            'https://pub.dev/packages/shared_preferences',
          ),
          _buildLicenseCard(
            'flutter_screenutil',
            'Apache License 2.0',
            'https://pub.dev/packages/flutter_screenutil',
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () {
              showLicensePage(
                context: context,
                applicationName: 'Afya Medicine Management',
                applicationVersion: '0.0.1',
              );
            },
            child: Text(
              'View All Licenses',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseCard(String package, String license, String url) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              license,
              style: TextStyle(
                fontSize: 13.sp,
                color: secondaryColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              url,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
