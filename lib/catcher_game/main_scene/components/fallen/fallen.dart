import 'dart:math';
import 'dart:ui';

import 'package:bezier/bezier.dart';
import 'package:flame/components.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/fallen/recycle_type.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/main_scene.dart';

class Fallen extends SpriteComponent with HasVisibility, HasGameRef<CatcherGame> {
  Fallen({
    required super.sprite,
    required super.paint,
    required this.scene,
    required this.type,
    required this.wave,
    required this.catchCallback,
    required this.cubicCurve,
    required this.speed,
    required this.isLeft,
    super.anchor = Anchor.center,
  });

  final RecycleType type;
  final int wave;
  final CatchCallback catchCallback;
  final MainScene scene;
  final QuadraticBezier cubicCurve;
  final double speed;
  final bool isLeft;
  double step = 0;
  double rotation = 6;

  @override
  void render(Canvas canvas) {
    sprite?.render(
      canvas,
      position: position,
      size: size,
      overridePaint: paint,
      anchor: anchor,
    );
  }

  @override
  void update(double dt) {
    if (isVisible && game.status == CatcherGameStatus.playing) {
      if (step <= 1) {
        isLeft ? angle += sin(step / rotation) : angle -= sin(step / rotation);

        x = cubicCurve.pointAt(step).x;
        y = cubicCurve.pointAt(step).y;
        step = step + speed;
      } else {
        angle = 0;
        isVisible = false;
        catchCallback(type);
        removeFromParent();
      }
    }
  }
}
