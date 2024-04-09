import 'package:vector_math/vector_math_64.dart';

class FinderConstraints {
  static const topPaddingPercentage = 0.15;
  static const trashAdditionalTopPaddingPercentage = 0.08;
  static const trashSizeFactor = 0.15;
  static const sidePadding = 5;

  static const extraRowsGenerated = 0;

  static Vector2 getTrashItemSize(double gameWidth) {
    final itemSize = gameWidth * FinderConstraints.trashSizeFactor;
    return Vector2(itemSize, itemSize);
  }
}
