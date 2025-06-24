import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<Map<String, String>> getDeviceInfo() async {
  final deviceInfo = DeviceInfoPlugin();
  String deviceId = '';
  String deviceName = '';

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id ?? '';
    deviceName = androidInfo.model ?? '';
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor ?? '';
    deviceName = iosInfo.utsname.machine ?? '';
  }
  return {
    'deviceId': deviceId,
    'deviceName': deviceName,
  };
}