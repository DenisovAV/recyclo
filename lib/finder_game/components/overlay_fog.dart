import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/finder_game/components/item.dart';
import 'package:flutter_game_challenge/finder_game/const/finder_constraints.dart';
import 'package:flutter_game_challenge/finder_game/finder_game.dart';
import 'package:flutter_game_challenge/finder_game/util/overlay_render_mode.dart';
import 'package:flutter_game_challenge/finder_game/util/overlay_renderer.dart';

class OverlayFog extends PositionComponent
    with DragCallbacks, CollisionCallbacks, HasGameReference<FinderGame> {
  OverlayFog({
    required super.size,
    required super.position,
    required this.topPadding,
  }) : super(priority: 5);

  final double topPadding;

  Vector2 get colliderSize => Vector2(
        size.x * FinderConstraints.colliderWidthFactor,
        size.y * FinderConstraints.colliderHeightFactor,
      );

  Vector2 get colliderPosition =>
      dragPosition -
      Vector2(
        colliderSize.x / 2,
        colliderSize.y / 2 +
            FinderConstraints.colliderVerticalOffsetFactor * size.y / 2,
      );

  Item? currentCollisionItem;
  Vector2 dragPosition = Vector2(0, 0);
  OverlayRenderMode renderMode = OverlayRenderMode.bushes;
  int numberOfTicks = 0;

  late final Image maskImage;
  late final Image fogImage;
  late final Image holeDecoration;
  late final RectangleHitbox collider;
  late final TimerComponent timerComponent;
  late final OverlayRenderer renderer;

  @override
  void onGameResize(Vector2 size) {
    super.size = size;
    renderer.resize(size);
    super.onGameResize(size);
  }

  @override
  Future<void> onLoad() async {
    _loadImages();

    renderer = OverlayRenderer(
      image: fogImage,
      maskImage: maskImage,
      decorationImage: holeDecoration,
      gameSize: size,
    );

    timerComponent = TimerComponent(
      period: .2,
      onTick: _onTick,
      autoStart: false,
      repeat: true,
    );
    await add(timerComponent);

    collider = RectangleHitbox(
      position: position,
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

    if (FinderConstraints.timerTicksLimit > numberOfTicks ||
        currentCollisionItem == null) return;

    itemToCollect.onCollected();
    game.gameState.collectTrash(itemToCollect);
  }

  @override
  Future<void> onDragStart(DragStartEvent event) async {
    super.onDragStart(event);
    renderMode = OverlayRenderMode.hole;
    dragPosition = event.localPosition;

    await add(collider
      ..position = colliderPosition
      ..size = colliderSize);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    dragPosition = event.localEndPosition;
    collider.position = colliderPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    renderMode = OverlayRenderMode.bushes;
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
      Assets.images.fog.path,
    );
    maskImage = Flame.images.fromCache(
      Assets.images.holeMask.path,
    );
    holeDecoration = Flame.images.fromCache(
      Assets.images.hole.path,
    );
  }

  @override
  void render(Canvas canvas) {
    renderer.render(
      mode: renderMode,
      canvas: canvas,
      paint: Paint(),
      dragPosition: dragPosition,
    );
  }
}
