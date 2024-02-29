import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter_game_challenge/clicker_game/game_models/trash_item.dart';

class Item extends PositionComponent with HasWorldReference {
  Item(this.trashData, {required super.position}) : super();
  static final baseSize = Vector2(76, 76);

  final TrashItemData trashData;
  late final SpriteComponent trashSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    trashSprite = SpriteComponent(
      sprite: Sprite(
        await Flame.images.load(
          trashData.assetPath.replaceFirst(
            'assets/images/',
            '',
          ),
        ),
      ),
      size: (baseSize * trashData.sizeMultiplier) - Vector2.all(10),
      anchor: Anchor.center,
    );
    add(trashSprite);

    final collider = RectangleHitbox.relative(
      Vector2(0.5, 0.5),
      parentSize: trashSprite.size,
    );

    trashSprite.add(collider);
  }

  @override
  void render(Canvas canvas) {
    // Do not draw anything for the body itself to ensure it's "transparent"
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

    await trashSprite.add(getResizeEvent()
      ..onComplete = () {
        removeFromParent();
      });
  }

  void onCorrectItem() {
    Effect getShakeEffect() {
      return SequenceEffect(
        [
          MoveEffect.by(
            Vector2(-4, 0),
            EffectController(
              duration: 0.1,
              alternate: true,
            ),
          ),
          MoveEffect.by(
            Vector2(4, 0),
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
        Colors.green,
        EffectController(
          duration: .5,
          alternate: true,
        ),
      );
    }

    trashSprite.add(getShakeEffect());
    trashSprite.add(getColorEffect());
  }
}