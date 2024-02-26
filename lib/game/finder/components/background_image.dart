import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/game/finder/finder_world.dart';

class BackgroundImage extends SpriteComponent {
  BackgroundImage({super.sprite});

  @override
  //ignore: must_call_super, intended function override
  void render(Canvas canvas) {
    final paint = Paint()
      ..colorFilter =
          ColorFilter.mode(const Color.fromARGB(66, 0, 0, 0), BlendMode.color);
    sprite?.renderRect(canvas, FinderWorld.worldAreaRect, overridePaint: paint);
  }
}
