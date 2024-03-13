import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/finder_game/asset_extensions.dart';
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
    await Flame.images.loadAll(
      [
        Assets.images.fog.path.trimAssetPath(),
        Assets.images.fogDark.path.trimAssetPath(),
        Assets.images.holeMask.path.trimAssetPath(),
        Assets.images.hole.path.trimAssetPath(),
      ],
    );

    final topPadding = size.y * FinderConstraints.topPaddingPercentage;

    gameState = FinderState(gameWidgetSize: size, topPadding: topPadding);
    await add(gameState);
    await add(
      BackgroundFog(
        sprite: Sprite(
          Flame.images.fromCache(
            Assets.images.fogDark.path.trimAssetPath(),
          ),
        ),
        position: Vector2(0, topPadding),
        size: size,
      ),
    );
    await addAll(gameState.trashItems.value);
    await add(
      OverlayFog(
        size: Vector2(size.x, size.y),
        position: Vector2(0, topPadding),
        topPadding: topPadding,
      ),
    );

    return super.onLoad();
  }
}
