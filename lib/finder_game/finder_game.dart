import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:recyclo/common/assets.dart';
import 'package:recyclo/common/extensions/platform/extended_platform.dart';
import 'package:recyclo/finder_game/components/background_fog.dart';
import 'package:recyclo/finder_game/components/overlay/overlay_fog.dart';
import 'package:recyclo/finder_game/events/finder_game_event.dart';
import 'package:recyclo/finder_game/finder_size.dart';
import 'package:recyclo/finder_game/finder_state.dart';
import 'package:recyclo/finder_game/util/finder_sound_player.dart';

class FinderGame extends Forge2DGame
    with TapDetector, HasCollisionDetection, KeyboardEvents, DragCallbacks {
  FinderGame() : super(zoom: 1);

  late final FinderState gameState;
  late final OverlayFog overlayFog;

  Vector2 dragPosition = Vector2(0, 0);

  StreamController<FinderGameEvent> streamController =
      StreamController.broadcast();
  Stream<FinderGameEvent> get eventStream => streamController.stream;

  @override
  Future<void> onLoad() async {
    final finderSize = ExtendedPlatform.isTv
        ? FinderSize.tv(gameSizeY: size.y)
        : FinderSize.mobile(gameSizeY: size.y);

    camera.moveTo(size / 2);

    await Flame.images.loadAll(
      [
        Assets.images.fog.path,
        Assets.images.fogDark.path,
        Assets.images.holeMask.path,
        Assets.images.hole.path,
      ],
    );

    gameState = FinderState(
      gameWidgetSize: size,
      finderSize: finderSize,
    );

    overlayFog = OverlayFog(
      position: Vector2(
        0,
        finderSize.fogPositionOffsetY,
      ),
      topPadding: finderSize.topPadding,
    );

    await addAll([
      gameState,
      FinderSoundPlayer(),
      BackgroundFog(
        sprite: Sprite(
          Flame.images.fromCache(
            ExtendedPlatform.isTv
                ? Assets.images.fogDarkTv.path
                : Assets.images.fogDark.path,
          ),
        ),
        position: Vector2(
          0,
          finderSize.fogPositionOffsetY,
        ),
        size: size,
      ),
    ]);

    await addAll(gameState.trashItems.value);
    await add(overlayFog);

    return super.onLoad();
  }

  @override
  Future<void> onDragStart(DragStartEvent event) async {
    super.onDragStart(event);
    dragPosition = event.localPosition;
    await overlayFog.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    dragPosition = event.localEndPosition;
    overlayFog.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    overlayFog.onDragEnd(event);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    return KeyEventResult.handled;
  }

  @override
  void onRemove() {
    streamController.close();
    super.onRemove();
  }
}
