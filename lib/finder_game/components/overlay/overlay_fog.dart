import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:recyclo/common/assets/assets.gen.dart';
import 'package:recyclo/common/extensions/platform.dart';
import 'package:recyclo/finder_game/components/item.dart';
import 'package:recyclo/finder_game/components/overlay/overlay_render_mode.dart';
import 'package:recyclo/finder_game/components/overlay/overlay_renderer.dart';
import 'package:recyclo/finder_game/const/finder_constraints.dart';
import 'package:recyclo/finder_game/events/event_type.dart';
import 'package:recyclo/finder_game/events/finder_game_event.dart';
import 'package:recyclo/finder_game/finder_game.dart';
import 'package:recyclo/finder_game/keyboard_arrow.dart';

const _keyboardShift = 10.0;

class OverlayFog extends PositionComponent
    with CollisionCallbacks, HasGameReference<FinderGame> {
  OverlayFog({
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
      period: .5,
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
      itemToCollect.onTryCollectItem(const Color.fromARGB(255, 240, 30, 30));
      game.streamController.add(FinderGameEvent(type: EventType.wrongItem));
      return;
    }

    itemToCollect.onTryCollectItem(const Color.fromARGB(255, 76, 255, 48));
    game.streamController.add(FinderGameEvent(type: EventType.correctItem));

    if (FinderConstraints.timerTicksLimit > numberOfTicks ||
        currentCollisionItem == null) return;

    itemToCollect.onCollected();
    game.streamController.add(FinderGameEvent(type: EventType.itemCollected));
    game.gameState.collectTrash(itemToCollect);
  }

  Future<void> onDragStart(DragStartEvent event) async {
    game.streamController.add(FinderGameEvent(type: EventType.dragStarted));
    renderMode = OverlayRenderMode.hole;
    dragPosition = event.localPosition - Vector2(0, topPadding);

    await add(
      collider
        ..position = colliderPosition
        ..size = colliderSize,
    );
  }

  void onDragUpdate(DragUpdateEvent event) {
    dragPosition = event.localEndPosition - Vector2(0, topPadding);
    collider.position = colliderPosition;
  }

  void onDragEnd(DragEndEvent event) {
    game.streamController.add(FinderGameEvent(type: EventType.dragEnded));
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

      if (ExtendedPlatform.isTv) {
      } else {
        _resetTimer();
      }
    }
  }

  void handleArrow(KeyboardArrow arrow) {
    switch (arrow) {
      case KeyboardArrow.up:
        dragPosition = Vector2(dragPosition.x, dragPosition.y - _keyboardShift);
      case KeyboardArrow.down:
        dragPosition = Vector2(dragPosition.x, dragPosition.y + _keyboardShift);
      case KeyboardArrow.left:
        dragPosition = Vector2(dragPosition.x - _keyboardShift, dragPosition.y);
      case KeyboardArrow.right:
        dragPosition = Vector2(dragPosition.x + _keyboardShift, dragPosition.y);
    }

    collider.position = colliderPosition;
  }

  Future<void> handleSelectKey() async {
    if (renderMode == OverlayRenderMode.bushes) {
      game.streamController.add(FinderGameEvent(type: EventType.dragStarted));
      renderMode = OverlayRenderMode.hole;

      dragPosition = size / 2;

      await add(
        collider
          ..position = colliderPosition
          ..size = colliderSize,
      );
    } else {
      game.streamController.add(FinderGameEvent(type: EventType.dragEnded));
      renderMode = OverlayRenderMode.bushes;
      remove(collider);
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
      ExtendedPlatform.isTv ? Assets.images.fogTv.path : Assets.images.fog.path,
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
