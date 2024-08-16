import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:recyclo/clicker_game/components/bound_component.dart';
import 'package:recyclo/clicker_game/components/cursor_component.dart';
import 'package:recyclo/clicker_game/components/trash_item_components.dart';
import 'package:recyclo/clicker_game/const/clicker_constraints.dart';
import 'package:recyclo/clicker_game/game_state.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/settings/persistence/settings_persistence.dart';

class ClickerGame extends Forge2DGame with TapDetector, HasKeyboardHandlerComponents {
  ClickerGame({required this.context, required this.settingsPersistence})
      : super(
          gravity: Vector2(0, -10),
          zoom: 1,
        );

  late final ClickerState gameState;
  final BuildContext context;
  final SettingsPersistence settingsPersistence;
  late final CursorComponent cursor;

  TrashItemComponent? focusedItem;

  @override
  Future<void> onLoad() async {
    camera.moveTo(size / 2);
    gameState = ClickerState(gameWidgetSize: size);
    await addAll(createBoundaries());
    await add(gameState);
    await addAll(gameState.trashItems.value);

    cursor = CursorComponent(
      position: size / 2,
      onItemSelected: () {},
      onPositionChanged: _onCursorPositionChanged,
      cursorSize: size,
      gameAreaSize: size,
      speed: 10,
    );
    if (ExtendedPlatform.isTv || ExtendedPlatform.isTizen) {
      await add(cursor);
    }

    return super.onLoad();
  }

  List<Component> createBoundaries() {
    final safePadding = MediaQuery.paddingOf(context).top + ClickerConstraints.topPadding;
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

    final tappedItem =
        gameState.trashItems.value.firstWhereOrNull((item) => item.containsPoint(worldPosition));

    if (tappedItem != null) {
      handleItemTapped(tappedItem);
    }
  }

  void handleItemTapped(TrashItemComponent tappedItem) {
    if (gameState.currentTargetTypes.value.lastOrNull == tappedItem.trashData.classification) {
      SemanticsService.announce(
        tappedItem.trashData.name,
        TextDirection.ltr,
      );
      tappedItem.onCollected();
      gameState.collectTrash(tappedItem);
    } else {
      tappedItem.onMiss();
      final isPenaltyEnbled = settingsPersistence.getPenaltyFlag();
      if (isPenaltyEnbled) {
        overlays.add(TimerReductionOrIncrementEffect.idReduction);
      }
    }
  }

  void _onCursorPositionChanged(Vector2 cursorPosition) {
    if (focusedItem?.containsPoint(cursorPosition) ?? false) {
    } else {
      for (final item in gameState.trashItems.value) {
        if (item.containsPoint(cursorPosition)) {
          if (focusedItem != item) {
            focusedItem?.setFocused(isFocused: false);
            item.setFocused(isFocused: true);
            focusedItem = item;
          }
        }
      }
    }
  }
}
