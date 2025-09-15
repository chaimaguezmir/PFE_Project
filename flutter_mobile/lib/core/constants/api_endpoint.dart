// lib/core/constants/api_endpoint.dart
// ignore_for_file: avoid_classes_with_only_static_members
abstract class ApiEndpoints {
  // Base URL
  static const String baseurl = 'http://102.219.178.221:8085/api';

  // Auth endpoints
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

  // Helper methods for dynamic endpoints
  static String prescriptionById(String id) => '$prescriptions/$id';
  static String treatmentById(String id) => '$treatments/$id';
  static String treatmentsByPrescription(String prescriptionId) => '$treatments/prescription/$prescriptionId';
  static String reminderById(String id) => '$reminders/$id';
  static String remindersWithMedications() => '$reminders/with-medications';
}