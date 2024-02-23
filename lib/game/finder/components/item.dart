import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class Item extends PositionComponent {
  Item({
    required super.position,
    required this.spritePath,
  });

  final _defaultColor = Colors.red;

  final String spritePath;

  late ShapeHitbox hitbox;
  late final SpriteComponent spriteComponent;

  static final effect = GlowEffect(
    10,
    EffectController(duration: 3),
  );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    await add(hitbox);

    final image = Flame.images.fromCache(spritePath);
    final sprite = Sprite(
      image,
      srcPosition: Vector2(0, 0),
      srcSize: image.size,
    );

    spriteComponent = SpriteComponent(
      sprite: sprite,
      size: sprite.srcSize,
      position: position,
      scale: Vector2.all(1.5),
    );

    size = spriteComponent.size;
    await add(spriteComponent);
  }
}
