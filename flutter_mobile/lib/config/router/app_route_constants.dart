class AppRouteName {
  // auth related screens
  static const String onboarding = 'onboarding';
  static const String signUp = 'signup';
  static const String signIn = 'signin';
  static const String accountVerification = 'accountVerification';
  static const String forgotPasswordEmailScreen = 'forgotPasswordEmailScreen';
  static const String forgotPasswordCodeScreen = 'forgotPasswordCodeScreen';
  static const String forgotPasswordNewPasswordScreen =
      'forgotPasswordNewPasswordScreen';
  static const String forgotPasswordSuccessScreen =
      'forgotPasswordSuccessScreen';
  static const String getStartedScreen = 'getStartedScreen';

  // group related screens
  static const String mainScreen = 'mainScreen';
  static const String groupScreen = 'groupScreen';
  static const String addGroupScreen = 'addGroupScreen'; // NEW
  static const String groupMembersScreen = 'groupMembersScreen';
  static const String addMemberScreen = 'addMemberScreen';
  static const String userManagementWelcome = 'userManagementWelcome';
  static const String userManagementPrescriptions = 'userManagementPrescriptions';
  static const String userManagementPrescriptionDetail = 'userManagementPrescriptionDetail';
  static const String userManagementTreatmentForm = 'userManagementTreatmentForm';


  // services related screens
  static const String services = 'services';
  static const String pharmacyBox = 'pharmacyBox';
  static const String barcodeScanner = 'barcodeScanner';
  static const String medicineSearchResult = 'medicineSearchResult';
  static const String medicationTracker = 'medicationTracker';
  static const String addMedicationManually = 'addMedicationManually';
  //home
  static const String home = 'home';
  static const String prescription = 'prescription';
  static const String prescriptionDetail = 'prescriptionDetail';
  static const String prescriptionForm = 'prescriptionForm';
  static const String treatmentForm = 'treatmentForm';

  // profile
  static const String profile = 'profile';
  static const String editProfile = 'editProfile';
}

class AppRoutePath {
  // auth related screens
  static const String onboarding = '/onboarding';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String accountVerification = '/accountVerification';
  static const String forgotPasswordEmailScreen = '/forgotPasswordEmailScreen';
  static const String forgotPasswordCodeScreen = '/forgotPasswordCodeScreen';
  static const String forgotPasswordNewPasswordScreen =
      '/forgotPasswordNewPasswordScreen';
  static const String forgotPasswordSuccessScreen =
      '/forgotPasswordSuccessScreen';
  static const String getStartedScreen = '/getStartedScreen';

  // home related screens
  static const String mainScreen = '/mainScreen';
  static const String groupScreen = '/groupScreen';
  static const String addGroupScreen = '/addGroupScreen'; // NEW
  static const String groupMembersScreen = '/groupScreen/groupMembersScreen';
  static const String addMemberScreen = '/groupScreen/groupMembersScreen/addMemberScreen';
  static const String userManagementWelcome = '/groupScreen/groupMembersScreen/userManagementWelcome';
  static const String userManagementPrescriptions = '/groupScreen/groupMembersScreen/userManagementPrescriptions';
  static const String userManagementPrescriptionDetail = '/groupScreen/groupMembersScreen/userManagementPrescriptionDetail';
  static const String userManagementTreatmentForm = '/groupScreen/groupMembersScreen/userManagementTreatmentForm';
  //services related screens
  static const String services = '/services';
  static const String pharmacyBox = '/services/pharmacyBox';
  static const String barcodeScanner = '/services/barcodeScanner';
  static const String medicineSearchResult = '/services/medicineSearchResult';
  static const String medicationTracker = '/services/medicationTracker';
  static const String addMedicationManually = '/services/addMedicationManually';

  //home
  static const String home = '/home';
  static const String prescription = '/home/prescription';
  static const String prescriptionDetail =
      '/home/prescription/prescriptionDetail';
  static const String prescriptionForm = '/home/prescriptionForm';
  static const String treatmentForm = '/home/prescriptionForm/treatmentForm';

  // profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/editProfile';

}
