import 'package:flutter_mobile/data/model/auth/login/login_result_model.dart';
import 'package:flutter_mobile/data/model/auth/sign_out_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginResult(LoginResultModel result) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', result.token);
  await prefs.setString('id', result.id);
  await prefs.setString('username', result.username);
  await prefs.setString('email', result.email);
  await prefs.setString('refreshToken', result.refreshToken);
  await prefs.setString('deviceId', result.deviceId);
  await prefs.setString('deviceName', result.deviceName);
  // Save other fields as needed
}
Future<void> clearSharedPref() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('refreshToken');
  await prefs.remove('id');
  await prefs.remove('username');
  await prefs.remove('email');
  await prefs.remove('deviceId');
  await prefs.remove('deviceName');
  // Remove other fields as needed
}

Future<SignOutRequestModel> getSignOutRequestModel() async {
  final prefs = await SharedPreferences.getInstance();
  final deviceName = prefs.getString('deviceName') ?? 'Unknown Devices';
  final deviceId = prefs.getString('deviceId') ?? '';
  final refreshToken = prefs.getString('refreshToken') ?? '';

  return SignOutRequestModel(
    deviceName: deviceName,
    deviceId: deviceId,
    refreshToken: refreshToken,
  );
}