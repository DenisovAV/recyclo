import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/finder_game/finder_game.dart';
import 'package:vector_math/vector_math_64.dart';

class OverlayFog extends PositionComponent
    with DragCallbacks, HasGameReference<FinderGame> {
  late Image maskImage;
  late Image fogImage;
  late Rect overlayTargetRect;

  final _collisionStartColor = const Color.fromARGB(255, 7, 255, 15);
  final _defaultColor = Color.fromARGB(255, 244, 6, 6);

  Vector2 get holePosition {
    return currentDragPosition;
  }

  Vector2 currentDragPosition = Vector2(0, 0);
  bool isDragInProgress = false;
  //HoleCollider collider = HoleCollider();
  late RectangleHitbox collider;

  OverlayFog({
    required super.size,
    required super.position,
  }) : super(priority: 5);

  @override
  Future<void> onLoad() async {
    overlayTargetRect = Rect.fromLTRB(
      0,
      0,
      game.size.x,
      game.size.y,
    );
    fogImage = Flame.images.fromCache(
      Assets.images.fog.path.replaceFirst(
        'assets/images/',
        '',
      ),
    );
    maskImage = Flame.images.fromCache(
      Assets.images.holeMask.path.replaceFirst(
        'assets/images/',
        '',
      ),
    );
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;

    collider = RectangleHitbox(
      position: position,
    )
      ..paint = defaultPaint
      ..renderShape = true;
  }

  @override
  Future<void> onDragStart(DragStartEvent event) async {
    super.onDragStart(event);
    isDragInProgress = true;
    currentDragPosition = event.localPosition;

    await add(
      collider
        ..position = currentDragPosition
        ..size = Vector2(30, 30),
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
    final rectSize = size.toSize();

    if (!isDragInProgress) {
      final inputSize =
          Size(fogImage.width.toDouble(), fogImage.height.toDouble());
      final fittedSizes = applyBoxFit(BoxFit.fill, inputSize, rectSize);
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

    final maskFittedSizes = applyBoxFit(BoxFit.cover, maskInputSize, rectSize);

    //set offset here
    final maskSourceRect = Alignment.center.inscribe(
      maskFittedSizes.source,
      Offset(
            maskFittedSizes.destination.width / 2 - currentDragPosition.x,
            maskFittedSizes.destination.height / 2 - currentDragPosition.y,
          ) &
          maskInputSize,
    );

    canvas
      ..saveLayer(overlayTargetRect, paint)
      ..drawImageRect(maskImage, maskSourceRect, overlayTargetRect, paint);

    final inputSize =
        Size(fogImage.width.toDouble(), fogImage.height.toDouble());
    final fittedSizes = applyBoxFit(BoxFit.fill, inputSize, rectSize);
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
