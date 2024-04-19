import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/common.dart';

class Background extends PositionComponent with HasGameRef<CatcherGame> {
  Background({
    required this.sprite,
  });

  final Sprite sprite;
  late Rect rect;

  static const double tilesWidth = 9;
  static const double tilesHeight = 20;

  @override
  void render(Canvas canvas) {
    sprite.renderRect(
      canvas,
      rect,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    rect = Rect.fromCenter(
      center: Offset(
        size.toSize().width / 2,
        size.toSize().height / game.scaleType.denominator,
      ),
      width: game.sizeConfig.tileSize * tilesWidth,
      height: game.sizeConfig.tileSize * tilesHeight,
    );

    super.onGameResize(size);
  }
}

extension on AccessibilityGameScaleType {
  double get denominator => switch (this) {
        AccessibilityGameScaleType.small => 2.05,
        AccessibilityGameScaleType.medium => 2.35,
        AccessibilityGameScaleType.large => 2.9,
      };
}
