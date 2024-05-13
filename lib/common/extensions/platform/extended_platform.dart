import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class ExtendedPlatform {
  static Future<void> initialize() async {
    if (kIsWeb) {
      return;
    }

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      isTv =
          androidInfo.systemFeatures.contains('android.software.leanback_only');
    } else if (Platform.isIOS || Platform.isWindows) {
      isTv = false;
    } else {
      isTv = Platform.isLinux;
    }
  }

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isApple => !kIsWeb && Platform.isIOS || Platform.isMacOS;

  static bool get isWeb => kIsWeb;

  static bool isTv = false;

  static bool isTizen =
      !kIsWeb && Platform.isLinux && !Platform.isAndroid && !Platform.isIOS;
}
