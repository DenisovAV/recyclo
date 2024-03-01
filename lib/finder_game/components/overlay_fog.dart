import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/finder_game/components/item.dart';
import 'package:flutter_game_challenge/finder_game/finder_game.dart';

class OverlayFog extends PositionComponent
    with DragCallbacks, CollisionCallbacks, HasGameReference<FinderGame> {
  static const double timerPeriod = 0.5;
  static const int timerTicksLimit = 4;

  Item? currentCollisionItem;

  Vector2 get holeHitboxPosition => dragPosition + Vector2(-12, -34);

  Vector2 dragPosition = Vector2(0, 0);
  bool isDragInProgress = false;
  int numberOfTicks = 0;

  late Image maskImage;
  late Image fogImage;
  late Rect overlayTargetRect;
  late RectangleHitbox collider;
  late TimerComponent timerComponent;

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

    timerComponent = TimerComponent(
      period: timerPeriod,
      onTick: _onTick,
      autoStart: false,
      repeat: true,
    );
    await add(timerComponent);

    collider = RectangleHitbox(
      position: position,
    );
  }

  @override
  Future<void> onDragStart(DragStartEvent event) async {
    super.onDragStart(event);
    isDragInProgress = true;
    dragPosition = event.localPosition;

    await add(
      collider
        ..position = holeHitboxPosition
        ..size = Vector2(20, 34),
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    dragPosition = event.localEndPosition;
    collider.position = holeHitboxPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    isDragInProgress = false;
    remove(collider);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other.parent is Item) {
      currentCollisionItem = other.parent as Item?;

      _resetTimer();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    numberOfTicks = 0;

    if (other.parent is Item && currentCollisionItem != other.parent) {
      return;
    }

    currentCollisionItem = null;
    timerComponent.timer.stop();
  }

  void _onTick() {
    numberOfTicks++;

    if (game.gameState.currentTargetTypes.value.lastOrNull !=
        currentCollisionItem?.trashData.classification) return;

    final itemToCollect = currentCollisionItem!;
    itemToCollect.onCorrectItem();

    if (timerTicksLimit > numberOfTicks || currentCollisionItem == null) return;

    itemToCollect.onCollected();
    game.gameState.collectTrash(itemToCollect);
  }

  void _resetTimer() {
    timerComponent.timer.start();
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

    final maskInputSize = Size(
        maskImage.width.toDouble() - 800, maskImage.height.toDouble() - 800);

    final maskFittedSizes = applyBoxFit(BoxFit.cover, maskInputSize, rectSize);

    final xmult = dragPosition.x / rectSize.width;
    final ymult = dragPosition.y / rectSize.height;

    final xmov = maskFittedSizes.source.width * xmult;
    final ymov = maskFittedSizes.source.height * ymult;

    final maskInputSize1 =
        Size(maskImage.width.toDouble(), maskImage.height.toDouble());

    final maskSourceRect = Alignment.center.inscribe(
      maskFittedSizes.source,
      Offset(
            maskFittedSizes.source.width / 2 - xmov,
            maskFittedSizes.source.height / 2 - ymov + 50,
          ) &
          maskInputSize1,
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
