import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:recyclo/common/assets/assets.gen.dart';
import 'package:recyclo/finder_game/components/background_fog.dart';
import 'package:recyclo/finder_game/components/overlay_fog.dart';
import 'package:recyclo/finder_game/const/finder_constraints.dart';
import 'package:recyclo/finder_game/finder_state.dart';

class FinderGame extends Forge2DGame with TapDetector, HasCollisionDetection {
  FinderGame() : super(zoom: 1);

  late final FinderState gameState;

  @override
  Future<void> onLoad() async {
    camera.moveTo(size / 2);
    await Flame.images.loadAll(
      [
        Assets.images.fog.path,
        Assets.images.fogDark.path,
        Assets.images.holeMask.path,
        Assets.images.hole.path,
      ],
    );

    final topPadding = size.y * FinderConstraints.topPaddingPercentage;

    gameState = FinderState(gameWidgetSize: size, topPadding: topPadding);
    await add(gameState);
    await add(
      BackgroundFog(
        sprite: Sprite(
          Flame.images.fromCache(
            Assets.images.fogDark.path,
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
