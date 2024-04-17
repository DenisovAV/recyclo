import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:recyclo/catcher_game/game.dart';

class Background extends SpriteComponent with HasGameRef<CatcherGame> {
  Background({super.sprite});

  late Rect rect;

  static const double tilesWidth = 9;
  static const double tilesHeight = 20;

  @override
  //ignore: must_call_super, intended function override
  void render(Canvas canvas) {
    sprite?.renderRect(canvas, rect);
  }

  @override
  void onGameResize(Vector2 size) {
    rect = Rect.fromLTWH(
        0,
        size.toSize().height - (game.sizeConfig.tileSize * tilesHeight),
        game.sizeConfig.tileSize * tilesWidth,
        game.sizeConfig.tileSize * tilesHeight);
    super.onGameResize(size);
  }
}
