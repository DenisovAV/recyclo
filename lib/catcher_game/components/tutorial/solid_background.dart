import 'dart:ui';

import 'package:flame/components.dart';
import 'package:recyclo/catcher_game/common/config.dart';
import 'package:recyclo/common.dart';

class SolidBackground extends PositionComponent with HasPaint {
  SolidBackground() {
    paint.color = _defaultSolidBackgroundColor.withAlpha(
      DebugBalancingTableConfig.backgroundAlpha,
    );
  }

  SolidBackground.withAlpha(int alpha) {
    paint.color = _defaultSolidBackgroundColor.withAlpha(alpha);
  }

  late Rect rect;
  static const _defaultSolidBackgroundColor =
      FlutterGameChallengeColors.tutorialBackground;

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
