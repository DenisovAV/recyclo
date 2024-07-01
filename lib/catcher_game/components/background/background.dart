import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:recyclo/catcher_game/game.dart';

class Background extends PositionComponent with HasGameRef<CatcherGame> {
  Background({
    required this.sprite,
    super.anchor = Anchor.bottomCenter,
  });

  final Sprite sprite;
  late Rect rect;

  static const double tilesWidth = 9;
  static const double tilesHeight = 20;

  @override
  void render(Canvas canvas) {
    if (isLoaded) {
      sprite.renderRect(
        canvas,
        rect,
      );
    }
  }

  @override
  void onGameResize(Vector2 size) {
    if (isLoaded) {
      final gameSize = game.canvasSize.toSize();
      // Get the aspect ratio of the sprite image
      final spriteAspectRatio = sprite.src.width / sprite.src.height;

      // Calculate the height of the Rect based on the aspect ratio and the width of the game canvas
      final rectHeight = gameSize.width / spriteAspectRatio;

      rect = Rect.fromLTWH(
        0,
        gameSize.height - rectHeight,
        gameSize.width,
        rectHeight,
      );
      super.onGameResize(size);
    }
  }
}
