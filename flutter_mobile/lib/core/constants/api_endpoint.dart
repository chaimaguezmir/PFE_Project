// lib/core/constants/api_endpoint.dart
// ignore_for_file: avoid_classes_with_only_static_members
abstract class ApiEndpoints {
  // Base URL
  static const String imageUrl = 'https://a2a7051a18d7.ngrok-free.app';
  static const String baseurl = 'https://a2a7051a18d7.ngrok-free.app/api';

  // Helper method to construct image URLs correctly (handles double slashes)
  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }

    // If already a full URL, return as is
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path.replaceAll(RegExp(r'(?<!:)//'), '/'); // Remove double slashes except after protocol
    }

    // If relative path, construct full URL
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$imageUrl$cleanPath';
  }


  static const String signUp = '$baseurl/auth/signup';
  static const String signIn = '$baseurl/auth/signin';
  static const String activateAccount = '$baseurl/auth/activate';
  static const String resendOTP = '$baseurl/auth/resendActivation';
  static const String forgotPassword = '$baseurl/auth/forgot-password';
  static const String checkResetCode = '$baseurl/auth/check-reset-code';
  static const String resetPassword = '$baseurl/auth/reset-password';
  static const String signOut = '$baseurl/auth/signout';

  // Medicine management endpoints
  static const String myMedicines = '$baseurl/my-medicines';
  static const String purchaseHistory = '$baseurl/purchase-history';
  static const String medicines = '$baseurl/medicines';
  static const String searchMedicines = '$baseurl/medicines/search';

  // Prescription management endpoints
  static const String prescriptions = '$baseurl/prescriptions';

  // Treatment management endpoints
  static const String treatments = '$baseurl/treatments';

  // Reminder management endpoints
  static const String reminders = '$baseurl/reminders';
  // Group Medical Management endpoints
  static const String groupMedical = '$baseurl/group-medical';


  // Helper methods for dynamic endpoints
  static String prescriptionById(String id) => '$prescriptions/$id';
  static String treatmentById(String id) => '$treatments/$id';
  static String treatmentsByPrescription(String prescriptionId) => '$treatments/prescription/$prescriptionId';
  static String reminderById(String id) => '$reminders/$id';
  static String remindersWithMedications() => '$reminders/with-medications';




  // ============================================
  // User Reminder Endpoints
  // ============================================

  static String getUserRemindersWithMedications(String groupId, String userId) =>
      '$groupMedical/groups/$groupId/users/$userId/reminders/with-medications';

  static String getUserReminders(String groupId, String userId) =>
      '$groupMedical/groups/$groupId/users/$userId/reminders';

  static String getUserReminderById(String groupId, String userId, String reminderId) =>
      '$groupMedical/groups/$groupId/users/$userId/reminders/$reminderId';

  static String markUserReminderAsTaken(String groupId, String userId, String reminderId) =>
      '$groupMedical/groups/$groupId/users/$userId/reminders/$reminderId/taken';

  static String updateUserReminder(String groupId, String userId, String reminderId) =>
      '$groupMedical/groups/$groupId/users/$userId/reminders/$reminderId';

  // ============================================
  // User Prescription Endpoints
  // ============================================

  static String getUserPrescriptions(String groupId, String userId) =>
      '$groupMedical/groups/$groupId/users/$userId/prescriptions';

  static String getUserPrescriptionById(String groupId, String userId, String prescriptionId) =>
      '$groupMedical/groups/$groupId/users/$userId/prescriptions/$prescriptionId';

  // ============================================
  // User Treatment Endpoints
  // ============================================

  static String getUserTreatments(String groupId, String userId) =>
      '$groupMedical/groups/$groupId/users/$userId/treatments';

  static String getUserTreatmentsByPrescription(String groupId, String userId, String prescriptionId) =>
      '$groupMedical/groups/$groupId/users/$userId/prescriptions/$prescriptionId/treatments';

  static String getUserTreatmentById(String groupId, String userId, String treatmentId) =>
      '$groupMedical/groups/$groupId/users/$userId/treatments/$treatmentId';
}

