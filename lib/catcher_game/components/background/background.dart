import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:recyclo/catcher_game/game.dart';
import 'package:recyclo/common/extensions/platform/extended_platform.dart';

class Background extends PositionComponent with HasGameRef<CatcherGame> {
  Background({
    required this.sprite,
    super.anchor = Anchor.bottomCenter,
  });

  final Sprite sprite;
  late Rect rect;

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

      if (ExtendedPlatform.isTv) {
        _createRectForTv(gameSize);
      } else {
        _createRect(gameSize);
      }

      super.onGameResize(size);
    }
  }

  void _createRectForTv(Size size) {
    rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );
  }

  void _createRect(Size size) {
    final spriteAspectRatio = sprite.src.width / sprite.src.height;

    final rectHeight = size.width / spriteAspectRatio;

    rect = Rect.fromLTWH(
      0,
      size.height - rectHeight,
      size.width,
      rectHeight,
    );
  }
}
