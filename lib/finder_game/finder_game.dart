import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:recyclo/common/assets.dart';
import 'package:recyclo/common/extensions/platform/extended_platform.dart';
import 'package:recyclo/finder_game/components/background_fog.dart';
import 'package:recyclo/finder_game/components/overlay/overlay_fog.dart';
import 'package:recyclo/finder_game/events/finder_game_event.dart';
import 'package:recyclo/finder_game/finder_size.dart';
import 'package:recyclo/finder_game/finder_state.dart';
import 'package:recyclo/finder_game/util/finder_sound_player.dart';

class FinderGame extends Forge2DGame with TapDetector, HasCollisionDetection {
  FinderGame() : super(zoom: 1);

  late final FinderState gameState;

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

    await addAll([
      gameState,
      FinderSoundPlayer(),
      BackgroundFog(
        sprite: Sprite(
          Flame.images.fromCache(
            Assets.images.fogDark.path,
          ),
        ),
        position: Vector2(
          0,
          finderSize.topPadding,
        ),
        size: size,
      ),
    ]);
    await addAll(gameState.trashItems.value);
    await add(
      OverlayFog(
        size: Vector2(
          size.x,
          size.y,
        ),
        position: Vector2(
          0,
          finderSize.topPadding,
        ),
        topPadding: finderSize.topPadding,
      ),
    );

    return super.onLoad();
  }

  @override
  void onRemove() {
    streamController.close();
    super.onRemove();
  }
}
