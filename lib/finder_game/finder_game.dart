import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/finder_game/components/background_fog.dart';
import 'package:flutter_game_challenge/finder_game/components/overlay_fog.dart';
import 'package:flutter_game_challenge/finder_game/const/finder_constraints.dart';
import 'package:flutter_game_challenge/finder_game/finder_state.dart';

class FinderGame extends Forge2DGame with TapDetector, HasCollisionDetection {
  FinderGame({
    required this.context,
  }) : super(
          zoom: 1,
        );

  late final FinderState gameState;
  final BuildContext context;

  @override
  Future<void> onLoad() async {
    camera.moveTo(size / 2);
    await Flame.images.loadAll([
      Assets.images.fog.path.replaceFirst(
        'assets/images/',
        '',
      ),
      Assets.images.fogDark.path.replaceFirst(
        'assets/images/',
        '',
      ),
      Assets.images.holeMask.path.replaceFirst(
        'assets/images/',
        '',
      ),
    ]);
    gameState = FinderState(gameWidgetSize: size);
    await add(gameState);
    await add(
      BackgroundFog(
        sprite: Sprite(
          Flame.images.fromCache(
            Assets.images.fogDark.path.replaceFirst('assets/images/', ''),
          ),
        ),
        position: Vector2(0, FinderConstraints.topPadding),
        size: size,
      ),
    );
    await addAll(gameState.trashItems.value);
    await add(
      OverlayFog(
        size: Vector2(size.x, size.y),
        position: Vector2(0, FinderConstraints.topPadding),
      ),
    );

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    return;
    final worldPosition = info.eventPosition.widget;

    final tappedItem = gameState.trashItems.value
        .firstWhereOrNull((item) => item.containsPoint(worldPosition));

    if (tappedItem != null) {
      if (gameState.currentTargetTypes.value.lastOrNull ==
          tappedItem.trashData.classification) {
        tappedItem.onCollected();
        gameState.collectTrash(tappedItem);
      } else {
        tappedItem.onMiss();
      }
    }
  }
}
