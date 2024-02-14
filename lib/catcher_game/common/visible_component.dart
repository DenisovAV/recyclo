import 'dart:ui';

import 'package:flame/components.dart';

class VisibleComponent extends SpriteComponent {
  VisibleComponent({
    required super.sprite,
    super.anchor = Anchor.center,
    this.isVisible = false,
  });

  bool isVisible;

  @override
  void render(Canvas canvas) {
    if (isVisible) {
      sprite?.render(
        canvas,
        position: position,
        size: size,
        overridePaint: paint,
        anchor: anchor,
      );
    }
  }
}
