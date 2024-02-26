import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/game/finder/components/item.dart';
import 'package:flutter_game_challenge/game/finder/finder_world.dart';

class HoleCollider extends PositionComponent
    with CollisionCallbacks, HasWorldReference<FinderWorld> {
  static const double maxTickCount = 2;

  final _collisionStartColor = const Color.fromARGB(255, 7, 255, 15);
  final _defaultColor = Colors.red;

  FinderWorld get finderWorld => world;

  Vector2 dragPosition = Vector2(0, 0);
  Item? currentCollisionItem;
  Timer timer = Timer(0, onTick: () => {});

  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..size = size
      ..paint = defaultPaint
      ..renderShape = true;

    await add(hitbox);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Item) {
      currentCollisionItem = other;
      hitbox.paint.color = _collisionStartColor;
      _resetTimer();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {
      hitbox.paint.color = _defaultColor;
      timer.stop();
      currentCollisionItem = null;
    }
  }

  void _onTick() {
    if (timer.current > 0 || currentCollisionItem == null) return;

    finderWorld.collectedItems.add(currentCollisionItem!);
    
    if (world.children.contains(currentCollisionItem)) {
      world.remove(currentCollisionItem!);
    }
  }

  void _resetTimer() {
    timer.stop();
    timer = Timer(maxTickCount, onTick: _onTick);
    timer.start();
  }
}
