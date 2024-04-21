import 'package:recyclo/common/extensions/platform/extended_platform_native.dart'
    if (dart.library.html) 'package:recyclo/common/extensions/platform/extended_platform_web.dart';

class ExtendedPlatform {
  static bool get isAndroid => targetIsAndroid;
  static bool get isIos => targetIsIOS;
  static bool get isWeb => targetIsWeb;
  static bool get isMacOs => targetIsMacOs;
  static bool get isMobile => isAndroid || isIos;
}
