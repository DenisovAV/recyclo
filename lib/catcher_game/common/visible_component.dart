import 'dart:ui';

import 'package:flame/components.dart';

class VisibleComponent extends PositionComponent with HasPaint {
  VisibleComponent({
    required this.sprite,
    super.anchor = Anchor.center,
    this.isVisible = false,
  });

  final Sprite sprite;
  bool isVisible;

  @override
  void render(Canvas canvas) {
    if (isVisible) {
      sprite.render(
        canvas,
        position: position,
        size: size,
        overridePaint: paint,
        anchor: anchor,
      );
    }
  }
}
