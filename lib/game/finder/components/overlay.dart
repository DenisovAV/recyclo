import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/game/finder/components/collider.dart';
import 'package:flutter_game_challenge/game/finder/finder_world.dart';

class OverlayFog extends PositionComponent with DragCallbacks {

  late Image maskImage;
  late Image fogImage;
  late Size fogSize;

  Rect get overlayTargetRect {
    return FinderWorld.worldAreaRect;
  }

  Vector2 get holePosition {
    return currentDragPosition;
  }

  Vector2 holeSpawnPosition = Vector2(0, 0);
  Vector2 currentDragPosition = Vector2(0, 0);
  bool isDragInProgress = false;
  HoleCollider collider = HoleCollider();

  @override
  Future<void> onLoad() async {
    fogImage = Flame.images.fromCache(Assets.images.fog.path);
    maskImage = Flame.images.fromCache(Assets.images.holeMask.path);
    fogSize = fogImage.size.toSize();
  }

  @override
  Future<void> onDragStart(DragStartEvent event) async {
    super.onDragStart(event);
    isDragInProgress = true;
    holeSpawnPosition = event.localPosition;
    await add(
      collider
        ..size = Vector2(100, 100)
        ..priority = 2,
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    currentDragPosition = event.localEndPosition;
    collider.position = currentDragPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    isDragInProgress = false;
    remove(collider);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();

    if (!isDragInProgress) {
      final inputSize =
          Size(fogImage.width.toDouble(), fogImage.height.toDouble());
      final fittedSizes = applyBoxFit(BoxFit.cover, inputSize, fogSize);
      final sourceRect = Alignment.center
          .inscribe(fittedSizes.source, Offset.zero & inputSize);

      canvas
        ..drawImageRect(
          fogImage,
          sourceRect,
          overlayTargetRect,
          paint,
        )
        ..restore();
      return;
    }

    final maskInputSize =
        Size(maskImage.width.toDouble(), maskImage.height.toDouble());

    final maskFittedSizes = applyBoxFit(BoxFit.cover, maskInputSize, fogSize);

    //set offset here
    final maskSourceRect = Alignment.center.inscribe(
      maskFittedSizes.source,
      Offset(
            overlayTargetRect.width / 2 - currentDragPosition.x,
            overlayTargetRect.height / 2 - currentDragPosition.y + 264,
          ) &
          maskInputSize,
    );

    canvas
      ..saveLayer(overlayTargetRect, paint)
      ..drawImageRect(maskImage, maskSourceRect, overlayTargetRect, paint);

    final inputSize =
        Size(fogImage.width.toDouble(), fogImage.height.toDouble());
    final fittedSizes = applyBoxFit(BoxFit.cover, inputSize, fogSize);
    final sourceRect =
        Alignment.center.inscribe(fittedSizes.source, Offset.zero & inputSize);

    canvas
      ..drawImageRect(
        fogImage,
        sourceRect,
        overlayTargetRect,
        paint..blendMode = BlendMode.srcIn,
      )
      ..restore();
  }
}
