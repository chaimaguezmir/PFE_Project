class ApiEndpoints {
  //
//  static const String baseurl = 'http://10.0.2.2:8081/api';
  static const String baseurl = 'https://a2c302975c6b.ngrok-free.app/api';
  static const String signUp = '$baseurl/auth/signup';
  static const String signIn = '$baseurl/auth/signin';
  static const String activateAccount = '$baseurl/auth/activate';
  static const String resendOTP = '$baseurl/auth/resendActivation';
  static const String forgotPassword = '$baseurl/auth/forgot-password';
  static const String checkResetCode = '$baseurl/auth/check-reset-code';
  static const String resetPassword = '$baseurl/auth/reset-password';
  static const String signOut = '$baseurl/auth/signout';
}
