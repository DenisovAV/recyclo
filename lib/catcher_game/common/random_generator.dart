import 'dart:math';

import 'package:flame/components.dart';

mixin RandomGenerator on Component {
  Random random = Random();

  double doubleInRange(double floor, double ceiling) =>
      random.nextDouble() * (ceiling - floor) + floor;
}
