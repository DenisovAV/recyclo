import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_game_challenge/clicker_game/game_models/trash_item.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';

class TrashItemComponent extends BodyComponent {
  TrashItemComponent(this.trashData, this.position) : super();
  static final baseSize = Vector2(50, 50);

  final Vector2 position;
  final TrashItemData trashData;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final backgroundSprite = SpriteComponent(
      sprite: Sprite(
        await Flame.images.load(Assets.images.clicker.images.cloud.path),
      ),
      size: baseSize * trashData.sizeMultiplier,
      position: Vector2.zero(),
      anchor: Anchor.center,
    );
    add(backgroundSprite);

    final trashSprite = SpriteComponent(
      sprite: Sprite(await Flame.images.load(trashData.assetPath)),
      size: (baseSize * trashData.sizeMultiplier) - Vector2.all(10),
      anchor: Anchor.center,
    );
    add(trashSprite);
  }

  @override
  void render(Canvas canvas) {
    // Do not draw anything for the body itself to ensure it's "transparent"
  }

  @override
  Body createBody() {
    final shape = CircleShape()
      ..radius = (baseSize.x * trashData.sizeMultiplier) / 2;

    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..restitution = 0.1
      ..friction = 0.5;

    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  bool containsPoint(Vector2 point) {
    final bodyPosition = body.position;
    final radius = (baseSize.x * trashData.sizeMultiplier) / 2;
    final distance = point.distanceTo(bodyPosition);

    return distance <= radius;
  }
}
