import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components.dart';

class Box extends SpriteComponent {
  Box({
    required super.sprite,
    required this.type,
    required this.order,
  }) {
    super.anchor = Anchor.center;
    paint = Paint()..filterQuality = FilterQuality.high;
  }

  int order;
  RecycleType type;
  bool isChosen = false;

  @override
  //ignore: must_call_super, intended function override
  void render(Canvas canvas) {
    sprite?.render(
      canvas,
      size: size,
      position: position,
      overridePaint: paint,
      anchor: anchor,
    );
    canvas
      ..save()
      ..clipRect(
        Rect.fromCenter(
          center: Offset(width / 2, height),
          width: width,
          height: height / 0.63,
        ),
        clipOp: ClipOp.difference,
      )
      ..restore();
  }
}
