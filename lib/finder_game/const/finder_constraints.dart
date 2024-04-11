import 'package:vector_math/vector_math_64.dart';

class FinderConstraints {
  static const topPaddingPercentage = 0.15;
  static const trashAdditionalTopPaddingPercentage = 0.08;
  static const trashSizeFactor = 0.15;
  static const sidePadding = 5;
  static const kVerticalHolePositionOffset = 56;
  static const kHoleZoomFactor = 0.2;
  static const timerTicksLimit = 3;
  static const extraRowsGenerated = 0;

  static const colliderHeightFactor = 0.08;
  static const colliderWidthFactor = 0.04;

  static const colliderVerticalOffset = -12;
  static const colliderHorizontalOffset = -34;

  static Vector2 getTrashItemSize(double gameWidth) {
    final itemSize = gameWidth * FinderConstraints.trashSizeFactor;
    return Vector2(itemSize, itemSize);
  }
}
