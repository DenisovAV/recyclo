

import 'package:flame/components.dart';

class BackgroundFog extends SpriteComponent {
  BackgroundFog({
    required super.sprite,
    required super.position,
    required super.size,
  }) : super();

  @override
  void onGameResize(Vector2 size) {
    super.size = size;
    super.onGameResize(size);
  }
}
