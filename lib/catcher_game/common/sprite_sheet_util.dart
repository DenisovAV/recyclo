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

  Sprite getSprite(int row, int column) => _sprites[row][column];

  //TODO(vikrech): try to make more efficient solution
  SpriteAnimation createAnimation({
    required double stepTime,
    bool loop = false,
  }) {
    final flattenList = <Sprite>[];

    _sprites.forEach((list) => list.forEach((itm) => flattenList.add(itm)));

    return SpriteAnimation.spriteList(
      flattenList.toList(),
      stepTime: stepTime,
      loop: loop,
    );
  }
}
