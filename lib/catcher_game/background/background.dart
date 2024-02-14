import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game_challenge/catcher_game/background.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';

class Background extends SpriteComponent with HasGameRef<CatcherGame> {
  Background({super.sprite});

  late Rect rect;

  @override
  void render(Canvas canvas) {
    sprite?.renderRect(canvas, rect);
  }

  @override
  void onGameResize(Vector2 size) {
    rect = Rect.fromLTWH(
        0,
        size.toSize().height - (game.sizeConfig.tileSize * BackgroundConfig.tilesLong),
        game.sizeConfig.tileSize * BackgroundConfig.tilesWide,
        game.sizeConfig.tileSize * BackgroundConfig.tilesLong);
  }
}
