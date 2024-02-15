import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';

class Item extends PositionComponent {
  Item({
    required super.position,
    required this.spritePath,
  });

  final String spritePath;

  late final SpriteComponent spriteComponent;

  @override
  Future<void> onLoad() async {
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

    await add(spriteComponent);
  }
}
