import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

Future<bool> isEmulator(BuildContext context) async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Theme.of(context).platform == TargetPlatform.android) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.isPhysicalDevice == false;
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.isPhysicalDevice == false;
  }
  return false; // Default to physical device for unsupported platforms
}
