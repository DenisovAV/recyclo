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
  static const int _kVerticalHolePositionOffset = 50;
  static const int _kVerticalDecorationOffset = 10;
  static const double _kHoleZoomFactorSizeInPixels = 800;
  static const double _kHoleDecorationSize = 146;

  static const double timerPeriod = 0.5;
  static const int timerTicksLimit = 4;

  Item? currentCollisionItem;

  Vector2 get holeHitboxPosition => dragPosition + Vector2(-12, -34);

  Vector2 dragPosition = Vector2(0, 0);
  bool isDragInProgress = false;
  int numberOfTicks = 0;

  late final Size fogImageSize;
  late final Size maskScaledSize;
  late final Size maskSize;

  late final Image maskImage;
  late final Image fogImage;
  late final Image holeDecoration;
  late final Rect overlayTargetRect;
  late final RectangleHitbox collider;
  late final TimerComponent timerComponent;
  late final SpriteComponent holeDecorationComponent;

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

    _loadImages();
    _getImageSizes();

    timerComponent = TimerComponent(
      period: timerPeriod,
      onTick: _onTick,
      autoStart: false,
      repeat: true,
    );
    await add(timerComponent);

    holeDecorationComponent = SpriteComponent.fromImage(holeDecoration)
      ..size = Vector2(_kHoleDecorationSize, _kHoleDecorationSize);

    collider = RectangleHitbox(
      position: position,
    );
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
    await add(holeDecorationComponent);
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
    remove(holeDecorationComponent);
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

  void _resetTimer() {
    timerComponent.timer.start();
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

  void _loadImages() {
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
    holeDecoration = Flame.images.fromCache(
      Assets.images.hole.path.replaceFirst(
        'assets/images/',
        '',
      ),
    );
  }

  void _getImageSizes() {
    fogImageSize = Size(fogImage.width.toDouble(), fogImage.height.toDouble());

    final maskWidth = maskImage.width.toDouble();
    final maskHeight = maskImage.height.toDouble();

    maskSize = Size(maskWidth, maskHeight);
    maskScaledSize = Size(
      maskWidth - _kHoleZoomFactorSizeInPixels,
      maskHeight - _kHoleZoomFactorSizeInPixels,
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    final rectSize = size.toSize();

    if (!isDragInProgress) {
      final fittedSizes = applyBoxFit(BoxFit.fill, fogImageSize, rectSize);
      final sourceRect = Alignment.center
          .inscribe(fittedSizes.source, Offset.zero & fogImageSize);

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

    holeDecorationComponent.position = Vector2(
        dragPosition.x - _kHoleDecorationSize / 2,
        dragPosition.y +
            _kVerticalHolePositionOffset / 2 -
            _kHoleDecorationSize +
            _kVerticalDecorationOffset);

    final maskFittedSizes = applyBoxFit(BoxFit.cover, maskScaledSize, rectSize);

    final fittedSourceSize = maskFittedSizes.source;
    final maskSourceRect = Alignment.center.inscribe(
      fittedSourceSize,
      Offset(
            fittedSourceSize.width / 2 -
                _getAxisOffset(
                  fittedMeasurement: maskFittedSizes.source.width,
                  axisDragPosition: dragPosition.x,
                  rectMeasurement: rectSize.width,
                ),
            fittedSourceSize.height / 2 -
                _getAxisOffset(
                  fittedMeasurement: maskFittedSizes.source.height,
                  axisDragPosition: dragPosition.y,
                  rectMeasurement: rectSize.height,
                ) +
                _kVerticalHolePositionOffset,
          ) &
          maskSize,
    );

    canvas
      ..saveLayer(overlayTargetRect, paint)
      ..drawImageRect(maskImage, maskSourceRect, overlayTargetRect, paint);

    final fittedSizes = applyBoxFit(BoxFit.fill, fogImageSize, rectSize);
    final sourceRect = Alignment.center
        .inscribe(fittedSizes.source, Offset.zero & fogImageSize);

    canvas
      ..drawImageRect(
        fogImage,
        sourceRect,
        overlayTargetRect,
        paint..blendMode = BlendMode.srcIn,
      )
      ..restore();
  }

  double _getAxisOffset({
    required double fittedMeasurement,
    required double axisDragPosition,
    required double rectMeasurement,
  }) {
    return fittedMeasurement * axisDragPosition / rectMeasurement;
  }
}
