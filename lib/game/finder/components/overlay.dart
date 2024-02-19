import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/game/finder/finder_world.dart';

class OverlayFog extends PositionComponent with DragCallbacks {
  late Image maskImage;
  late Image fogImage;
  late Size fogSize;

  @override
  Future<void> onLoad() async {
    fogImage = Flame.images.fromCache(Assets.images.fog.path);
    maskImage = Flame.images.fromCache(Assets.images.holeMask.path);
    fogSize = fogImage.size.toSize();

    final sprite = Sprite(
      fogImage,
      srcPosition: Vector2(0, 0),
      srcSize: fogImage.size,
    );
    final fogSpriteComponent = SpriteComponent(
      sprite: sprite,
      size: sprite.srcSize,
      position: Vector2(0, 0 + FinderWorld.kTopGap),
      scale: Vector2.all(1),
    );
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {}

  @override
  void render(Canvas canvas) {
    final paint = Paint();

    const destinationRect =
        Rect.fromLTRB(0, 200, 1000, 2060); //hole size and finger location
    final outputSize = fogSize;

    final maskInputSize =
        Size(maskImage.width.toDouble(), maskImage.height.toDouble());
    final maskFittedSizes =
        applyBoxFit(BoxFit.cover, maskInputSize, outputSize);

    final maskSourceSize = maskFittedSizes.source;

    final maskSourceRect =
        Alignment.center.inscribe(maskSourceSize, Offset.zero & maskInputSize);

    canvas
      ..saveLayer(destinationRect, paint)
      ..drawImageRect(maskImage, maskSourceRect, destinationRect, paint);

    final inputSize =
        Size(fogImage.width.toDouble(), fogImage.height.toDouble());
    final fittedSizes = applyBoxFit(BoxFit.cover, inputSize, outputSize);
    final sourceSize = fittedSizes.source;
    final sourceRect =
        Alignment.center.inscribe(sourceSize, Offset.zero & inputSize);

    canvas
      ..drawImageRect(
        fogImage,
        sourceRect,
        destinationRect,
        paint..blendMode = BlendMode.srcIn,
      )
      ..restore();
  }
}
