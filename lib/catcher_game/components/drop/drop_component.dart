import 'dart:math';
import 'dart:ui';

import 'package:bezier/bezier.dart';
import 'package:flame/components.dart';
import 'package:flutter_game_challenge/catcher_game/components.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene.dart';
import 'package:flutter_game_challenge/common.dart';

class DropComponent extends PositionComponent
    with HasGameRef<CatcherGame>, HasPaint {
  DropComponent({
    required this.sprite,
    required this.type,
    required this.wave,
    required this.catchCallback,
    required this.cubicCurve,
    required this.speed,
    required this.isLeft,
  }) {
    super.anchor = Anchor.center;
    paint = Paint()..filterQuality = FilterQuality.high;
  }

  final Sprite sprite;
  final ItemType type;
  final int wave;
  final CatchCallback catchCallback;
  final QuadraticBezier cubicCurve;
  final double speed;
  final bool isLeft;
  double step = 0;
  double rotation = 6;

  @override
  void render(Canvas canvas) {
    sprite.render(
      canvas,
      position: position,
      size: size,
      overridePaint: paint,
      anchor: anchor,
    );
  }

  @override
  void update(double dt) {
    if (game.status == CatcherGameStatusType.playing) {
      if (step <= 1) {
        isLeft ? angle += sin(step / rotation) : angle -= sin(step / rotation);

        x = cubicCurve.pointAt(step).x;
        y = cubicCurve.pointAt(step).y;
        step = step + speed;
      } else {
        angle = 0;
        catchCallback(type);
        removeFromParent();
      }
    }
  }
}
