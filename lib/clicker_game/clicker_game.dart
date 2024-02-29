import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game_challenge/clicker_game/components/bound_component.dart';
import 'package:flutter_game_challenge/clicker_game/const/clicker_constraints.dart';
import 'package:flutter_game_challenge/clicker_game/game_state.dart';

class ClickerGame extends Forge2DGame with TapDetector {
  ClickerGame({
    required this.context,
  }) : super(
          gravity: Vector2(0, -10),
          zoom: 1,
        );

  late final ClickerState gameState;
  final BuildContext context;

  @override
  Future<void> onLoad() async {
    camera.moveTo(size / 2);
    gameState = ClickerState(gameWidgetSize: size);
    await addAll(createBoundaries());
    await add(gameState);
    await addAll(gameState.trashItems.value);

    return super.onLoad();
  }

  List<Component> createBoundaries() {
    final safePadding =
        MediaQuery.paddingOf(context).top + ClickerConstraints.topPadding;
    const bottomThreshold = 200.0;
    final screenSize = size;

    final topLeft = Vector2(0, safePadding);
    final topRight = Vector2(screenSize.x, safePadding);
    final bottomRight = Vector2(screenSize.x, screenSize.y + bottomThreshold);
    final bottomLeft = Vector2(0, screenSize.y + bottomThreshold);

    return [
      BoundComponents(topLeft, topRight),
      BoundComponents(topRight, bottomRight),
      BoundComponents(topLeft, bottomLeft),
    ];
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
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
