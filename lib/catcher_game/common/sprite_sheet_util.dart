import 'dart:ui';

import 'package:flame/components.dart';

///slightly changed original flame util class in animation method
class SpriteSheetUtil {
  SpriteSheetUtil({
    required Image image,
    required double textureWidth,
    required double textureHeight,
    required int columns,
    required int rows,
  }) {
    _sprites = List.generate(
      rows,
      (y) => List.generate(
        columns,
        (x) => Sprite(
          image,
          srcPosition: Vector2(x * textureWidth, y * textureHeight),
          srcSize: Vector2(textureWidth, textureHeight),
        ),
      ),
    );
  }

  late final List<List<Sprite>> _sprites;

  SpriteAnimation createAnimation({
    required double stepTime,
    bool loop = false,
  }) {
    final flattenList = <Sprite>[];

    for (final innerSpriteListItem in _sprites) {
      for (var i = 0; i < innerSpriteListItem.length; i++) {
        final sprite = innerSpriteListItem[i];
        flattenList.add(sprite);
      }
    }

    return SpriteAnimation.spriteList(
      flattenList.toList(),
      stepTime: stepTime,
      loop: loop,
    );
  }
}
