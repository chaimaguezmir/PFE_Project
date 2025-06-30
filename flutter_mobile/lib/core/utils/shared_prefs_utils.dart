import 'package:flutter_mobile/data/model/auth/login/login_result_model.dart';
import 'package:flutter_mobile/data/model/auth/sign_out_request_model.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtils {
  final SharedPreferences _prefs = sl<SharedPreferences>();
   Future<void> clearSharedPref() async {
    await Future.wait([
      _prefs.remove('token'),
      _prefs.remove('refreshToken'),
      _prefs.remove('id'),
      _prefs.remove('username'),
      _prefs.remove('email'),
      _prefs.remove('deviceId'),
      _prefs.remove('deviceName'),
    ]);

    // Remove other fields as needed
  }
}

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

Future<void> clearSharedPref(SharedPreferences prefs) async {
  await Future.wait([
    prefs.remove('token'),
    prefs.remove('refreshToken'),
    prefs.remove('id'),
    prefs.remove('username'),
    prefs.remove('email'),
    prefs.remove('deviceId'),
    prefs.remove('deviceName'),
  ]);

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
