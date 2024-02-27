import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Item extends SpriteComponent {
  Item({
    required super.sprite,
    required super.position,
    super.priority = 2,
  });

  final Paint paint = Paint()..filterQuality = FilterQuality.high;
  final _defaultColor = Colors.red;

  late ShapeHitbox hitbox;
  late final SpriteComponent spriteComponent;

  static final effect = GlowEffect(
    10,
    EffectController(duration: 3),
  );

  @override
  //ignore: must_call_super, intended function override
  void render(Canvas canvas) {
    sprite?.render(
      canvas,
      position: position,
      size: size,
      overridePaint: paint,
      anchor: anchor,
    );
  }

  @override
  void onLoad() {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;

    add(
      RectangleHitbox()
        ..paint = defaultPaint
        ..renderShape = true,
    );
  }
}
