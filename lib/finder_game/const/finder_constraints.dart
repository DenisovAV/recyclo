import 'package:vector_math/vector_math_64.dart';

class FinderConstraints {
  static const topPaddingPercentageMobile = 0.15;
  static const topPaddingPercentageTv = 0.12;
  static const trashAdditionalTopPaddingPercentageMobile = 0.08;
  static const trashAdditionalTopPaddingPercentageTv = 0.03;
  static const trashSizeFactorMobile = 0.15;
  static const trashSizeFactorTv = 0.06;
  static const sidePadding = 5;
  static const verticalHoleOffset = 140;
  static const holeZoomFactor = 0.40;
  static const timerTicksLimit = 2;
  static const extraRowsGenerated = 0;

  static const colliderHeightFactor = 0.045;
  static const colliderWidthFactor = 0.025;
  static const colliderVerticalOffsetFactor = 0.12;

  static const maxGameWidth = 500.0;
  static const minGameWidth = 320.0;
  static const maxGameHeight = 1100.0;
  static const minGameHeight = 500.0;

  static Vector2 getTrashItemSize(double gameWidth, double trashSizeFactor) {
    final itemSize = gameWidth * trashSizeFactor;
    return Vector2(itemSize, itemSize);
  }
}
