import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class ExtendedPlatform {
  static Future<void> initialize() async {
    if (kIsWeb) {
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      isTv = androidInfo.systemFeatures.contains('android.software.leanback_only');
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      const tvMode = String.fromEnvironment('TV_MODE');
      isTv = tvMode == 'ON';
    } else {
      isTv = false;
    }
  }

  static bool get isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isApple =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static bool get isWeb => kIsWeb;

  static bool isTv = false;

  static bool get isAppleTv => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && isTv;

  static bool isTizen = !kIsWeb &&
      defaultTargetPlatform == TargetPlatform.linux &&
      defaultTargetPlatform != TargetPlatform.android &&
      defaultTargetPlatform != TargetPlatform.iOS;
}
