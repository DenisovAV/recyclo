import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:recyclo/clicker_game/game_models/trash_item.dart';
import 'package:recyclo/common/assets/assets.gen.dart';

class TrashItemComponent extends BodyComponent {
  TrashItemComponent(
    this.trashData,
    this.position,
    this.baseSize,
  ) : super();

  final Vector2 baseSize;
  final Vector2 position;
  final TrashItemData trashData;
  late final SpriteComponent backgroundSprite;
  late final SpriteComponent trashSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    backgroundSprite = SpriteComponent(
      sprite: Sprite(
        await Flame.images.load(
          Assets.images.clicker.images.cloud.path,
        ),
      ),
      size: baseSize * trashData.sizeMultiplier,
      position: Vector2.zero(),
      anchor: Anchor.center,
    );
    add(backgroundSprite);

    trashSprite = SpriteComponent(
      sprite: Sprite(
        await Flame.images.load(trashData.assetPath),
      ),
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

  void onCollected() async {
    Effect getResizeEvent() {
      return SequenceEffect(
        [
          ScaleEffect.by(
            Vector2(1.5, 1.5),
            EffectController(
              duration: 0.1,
            ),
          ),
          ScaleEffect.by(
            Vector2(.1, .1),
            EffectController(
              duration: 0.1,
            ),
          ),
        ],
        infinite: false,
      );
    }

    await backgroundSprite.add(getResizeEvent());
    await trashSprite.add(getResizeEvent()
      ..onComplete = () {
        removeFromParent();
      });
  }

  void onMiss() {
    Effect getShakeEffect() {
      return SequenceEffect(
        [
          MoveEffect.by(
            Vector2(-5, 0),
            EffectController(
              duration: 0.1,
              alternate: true,
            ),
          ),
          MoveEffect.by(
            Vector2(5, 0),
            EffectController(
              duration: 0.1,
              alternate: true,
            ),
          ),
        ],
        infinite: false,
        alternate: true,
      );
    }

    Effect getColorEffect() {
      return ColorEffect(
        Colors.red.shade400,
        EffectController(
          duration: .5,
          alternate: true,
        ),
      );
    }

    backgroundSprite.add(getShakeEffect());
    backgroundSprite.add(getColorEffect());
    trashSprite.add(getShakeEffect());
    trashSprite.add(getColorEffect());
  }
}
