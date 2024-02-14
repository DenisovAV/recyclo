import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game_challenge/catcher_game/common/config.dart';

class SolidBackground extends PositionComponent {
  SolidBackground() {
    paint.color = _defaultSolidBackgroundColor.withAlpha(DebugBalancingTableConfig.backgroundAlpha);
  }

  SolidBackground.withAlpha(int alpha) {
    paint.color = _defaultSolidBackgroundColor.withAlpha(alpha);
  }

  late Rect rect;
  final Paint paint = Paint();
  static const _defaultSolidBackgroundColor = Color(0xFFE0EBF1);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect, paint);
  }

  @override
  void onGameResize(Vector2 size) {
    rect = Rect.fromLTWH(x, y, width, height);
    super.onGameResize(size);
  }
}
