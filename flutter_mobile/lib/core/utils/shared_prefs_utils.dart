import 'package:flutter_mobile/core/constants/api_endpoint.dart';
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
      _prefs.remove('firstName'),
      _prefs.remove('lastName'),
      _prefs.remove('phoneNumber'),
      _prefs.remove('weight'),
      _prefs.remove('height'),
      _prefs.remove('bloodGroup'),
      _prefs.remove('gender'),
      _prefs.remove('birthDate'),
      _prefs.remove('smokingStatus'),
      _prefs.remove('alcoholConsumption'),
      _prefs.remove('exerciseRegularly'),
      _prefs.remove('familyHistoryHeartDisease'),
      _prefs.remove('hypertensionHistory'),
      _prefs.remove('heartDisease'),
      _prefs.remove('diabetes'),
      _prefs.remove('cholesterol'),
      _prefs.remove('allergies'),
      _prefs.remove('profileImageUrl'),
    ]);
  }

  // Get user profile data
  Future<Map<String, dynamic>> getUserProfile() async {
    return {
      'username': _prefs.getString('username') ?? '',
      'email': _prefs.getString('email') ?? '',
      'firstName': _prefs.getString('firstName'),
      'lastName': _prefs.getString('lastName'),
      'phoneNumber': _prefs.getString('phoneNumber'),
      'profileImageUrl': _prefs.getString('profileImageUrl'),
      'weight': _prefs.getDouble('weight'),
      'height': _prefs.getDouble('height'),
      'bloodGroup': _prefs.getString('bloodGroup'),
      'gender': _prefs.getString('gender'),
      'birthDate': _prefs.getString('birthDate'),
      'smokingStatus': _prefs.getBool('smokingStatus'),
      'alcoholConsumption': _prefs.getBool('alcoholConsumption'),
      'exerciseRegularly': _prefs.getBool('exerciseRegularly'),
      'familyHistoryHeartDisease': _prefs.getBool('familyHistoryHeartDisease'),
      'hypertensionHistory': _prefs.getBool('hypertensionHistory'),
      'heartDisease': _prefs.getBool('heartDisease'),
      'diabetes': _prefs.getBool('diabetes'),
      'cholesterol': _prefs.getBool('cholesterol'),
      'allergies': _prefs.getBool('allergies'),
    };
  }

  // Get display name
  String getDisplayName() {
    final firstName = _prefs.getString('firstName');
    final lastName = _prefs.getString('lastName');
    final username = _prefs.getString('username') ?? 'User';

    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName;
    } else if (lastName != null) {
      return lastName;
    }
    return username;
  }

  // Get avatar path with default
  String getAvatarPath() {
    final profileImageUrl = _prefs.getString('profileImageUrl');
    return profileImageUrl?.isNotEmpty == true
        ? profileImageUrl!
        : 'lib/config/assets/images/default_avatar.jpg';
  }
}

Future<void> saveLoginResult(LoginResultModel result) async {
  final prefs = await SharedPreferences.getInstance();

  // Save basic auth data
  await prefs.setString('token', result.token);
  await prefs.setString('id', result.id);
  await prefs.setString('username', result.username);
  await prefs.setString('email', result.email);
  await prefs.setString('refreshToken', result.refreshToken);
  await prefs.setString('deviceId', result.deviceId);
  await prefs.setString('deviceName', result.deviceName);

  // Save profile data
  if (result.firstName != null) {
    await prefs.setString('firstName', result.firstName!);
  }
  if (result.lastName != null) {
    await prefs.setString('lastName', result.lastName!);
  }
  if (result.phoneNumber != null) {
    await prefs.setString('phoneNumber', result.phoneNumber!);
  }
  if (result.weight != null) {
    await prefs.setDouble('weight', result.weight!);
  }
  if (result.height != null) {
    await prefs.setDouble('height', result.height!);
  }
  if (result.bloodGroup != null) {
    await prefs.setString('bloodGroup', result.bloodGroup!);
  }
  if (result.gender != null) {
    await prefs.setString('gender', result.gender!);
  }
  if (result.birthDate != null) {
    await prefs.setString('birthDate', result.birthDate!);
  }
  if (result.smokingStatus != null) {
    await prefs.setBool('smokingStatus', result.smokingStatus!);
  }
  if (result.alcoholConsumption != null) {
    await prefs.setBool('alcoholConsumption', result.alcoholConsumption!);
  }
  if (result.exerciseRegularly != null) {
    await prefs.setBool('exerciseRegularly', result.exerciseRegularly!);
  }
  if (result.familyHistoryHeartDisease != null) {
    await prefs.setBool('familyHistoryHeartDisease', result.familyHistoryHeartDisease!);
  }
  if (result.hypertensionHistory != null) {
    await prefs.setBool('hypertensionHistory', result.hypertensionHistory!);
  }
  if (result.heartDisease != null) {
    await prefs.setBool('heartDisease', result.heartDisease!);
  }
  if (result.diabetes != null) {
    await prefs.setBool('diabetes', result.diabetes!);
  }
  if (result.cholesterol != null) {
    await prefs.setBool('cholesterol', result.cholesterol!);
  }
  if (result.allergies != null) {
    await prefs.setBool('allergies', result.allergies!);
  }

  // Save profile image URL or set default
  if (result.profileImageUrl != null && result.profileImageUrl!.isNotEmpty) {
    await prefs.setString('profileImageUrl', ApiEndpoints.baseurl+result.profileImageUrl!);
  } else {
    await prefs.setString('profileImageUrl', 'lib/config/assets/images/default_avatar.jpg');
  }
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
    prefs.remove('firstName'),
    prefs.remove('lastName'),
    prefs.remove('phoneNumber'),
    prefs.remove('weight'),
    prefs.remove('height'),
    prefs.remove('bloodGroup'),
    prefs.remove('gender'),
    prefs.remove('birthDate'),
    prefs.remove('smokingStatus'),
    prefs.remove('alcoholConsumption'),
    prefs.remove('exerciseRegularly'),
    prefs.remove('familyHistoryHeartDisease'),
    prefs.remove('hypertensionHistory'),
    prefs.remove('heartDisease'),
    prefs.remove('diabetes'),
    prefs.remove('cholesterol'),
    prefs.remove('allergies'),
    prefs.remove('profileImageUrl'),
  ]);
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