import 'package:flutter/material.dart';

abstract class Dimensions {
  static const defaultLandingDesktopConstraints = BoxConstraints(maxWidth: 1500);
  static BoxConstraints landingSmallDesktopConstraints(double maxWidth) => BoxConstraints(maxWidth: maxWidth - 50);
}
