import 'package:vector_math/vector_math_64.dart';

class FinderConstraints {
  static const topPaddingPercentage = 0.15;
  static const trashAdditionalTopPaddingPercentage = 0.08;
  static const trashSizeFactor = 0.15;
  static const sidePadding = 5;
  static const verticalHoleOffset = 140;
  static const holeZoomFactor = 0.40;
  static const timerTicksLimit = 3;
  static const extraRowsGenerated = 0;

  static const colliderHeightFactor = 0.045;
  static const colliderWidthFactor = 0.025;
  static const colliderVerticalOffsetFactor = 0.12;

  static Vector2 getTrashItemSize(double gameWidth) {
    final itemSize = gameWidth * FinderConstraints.trashSizeFactor;
    return Vector2(itemSize, itemSize);
  }
}
