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
  OverlayFog({
    required super.size,
    required super.position,
    required this.topPadding,
  }) : super(priority: 5);

  static const int _kVerticalHolePositionOffset = 56;
  static const double _kHoleZoomFactor = 8;

  static const double timerPeriod = .5;
  static const int timerTicksLimit = 4;

  Item? currentCollisionItem;

  Vector2 get holeHitboxPosition => dragPosition + Vector2(-12, -34);

  Rect overlayTargetRect = Rect.fromLTWH(0, 0, 0, 0);
  Vector2 dragPosition = Vector2(0, 0);
  bool isDragInProgress = false;
  int numberOfTicks = 0;
  double zoomFactorInPixels = 0;
  double maskWidth = 0;
  double maskHeight = 0;

  final double topPadding;

  late Size maskSize;
  late Size maskScaledSize;
  late Size fogImageSize;

  late final Image maskImage;
  late final Image fogImage;
  late final Image holeDecoration;
  late final RectangleHitbox collider;
  late final TimerComponent timerComponent;

  @override
  void onGameResize(Vector2 size) {
    super.size = size;
    zoomFactorInPixels = _kHoleZoomFactor * size.x;
    _setTargetRectSize(size);
    _setMaskSizes(maskWidth, maskHeight);

    super.onGameResize(size);
  }

  @override
  Future<void> onLoad() async {
    _setTargetRectSize(size);

    _loadImages();
    _setImageSizes();
    _setMaskSizes(maskWidth, maskHeight);

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

  void _setTargetRectSize(Vector2 size) {
    overlayTargetRect = Rect.fromLTRB(
      0,
      0,
      size.x,
      size.y,
    );
  }

  void _onTick() {
    numberOfTicks++;

    final itemToCollect = currentCollisionItem!;

    if (game.gameState.currentTargetTypes.value.lastOrNull !=
        itemToCollect.trashData.classification) {
      itemToCollect.onTryCollectItem(Color.fromARGB(255, 240, 30, 30));
      return;
    }

    itemToCollect.onTryCollectItem(Color.fromARGB(255, 76, 255, 48));

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

  void _setImageSizes() {
    fogImageSize = Size(fogImage.width.toDouble(), fogImage.height.toDouble());
    maskWidth = maskImage.width.toDouble();
    maskHeight = maskImage.height.toDouble();
  }

  void _setMaskSizes(double maskWidth, double maskHeight) {
    maskSize = Size(maskWidth, maskHeight);

    zoomFactorInPixels = _kHoleZoomFactor * size.x;
    maskScaledSize = Size(
      maskWidth - zoomFactorInPixels,
      maskHeight - zoomFactorInPixels,
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

      canvas
      ..drawImageRect(
          holeDecoration, maskSourceRect, overlayTargetRect, paint..blendMode = BlendMode.srcOver);
  }

  double _getAxisOffset({
    required double fittedMeasurement,
    required double axisDragPosition,
    required double rectMeasurement,
  }) {
    return fittedMeasurement * axisDragPosition / rectMeasurement;
  }
}
