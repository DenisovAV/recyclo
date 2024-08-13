import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';

import 'package:recyclo/clicker_game/clicker_game.dart';
import 'package:recyclo/common.dart';

class CursorComponent extends PositionComponent with KeyboardHandler, HasGameRef<ClickerGame> {
  CursorComponent({
    required Vector2 position,
    required this.onPositionChanged,
    required this.onItemSelected,
    required this.cursorSize,
    required this.gameAreaSize,
    this.speed = 5,
  }) : super(
          position: position,
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  final double speed;
  final void Function(Vector2) onPositionChanged;
  final VoidCallback onItemSelected;
  final Vector2 cursorSize;
  final Vector2 gameAreaSize;
  late final SpriteComponent cursorSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    cursorSprite = SpriteComponent(
      sprite: Sprite(
        await Flame.images.load(Assets.cursors.cursorRested.path),
      ),
      size: Vector2(100, 100),
    );
    add(cursorSprite);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.arrowUp) {
        final potentialPosition = position.y - speed;
        position.y = max(0, potentialPosition);
      } else if (key == LogicalKeyboardKey.arrowDown) {
        final potentialPosition = position.y + speed;
        position.y = min(potentialPosition, gameAreaSize.y);
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        final potentialPosition = position.x - speed;
        position.x = max(0, potentialPosition);
      } else if (key == LogicalKeyboardKey.arrowRight) {
        final potentialPosition = position.x + speed;
        position.x = min(gameAreaSize.x, potentialPosition);
      } else if (key == LogicalKeyboardKey.space) {
        // Implement selection logic
        _selectItem();
        onItemSelected();
      }
      onPositionChanged(position);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _selectItem() {
    // Custom selection logic
    final selectedItem =
        game.gameState.trashItems.value.firstWhereOrNull((item) => item.containsPoint(position));
    if (selectedItem != null) {
      game.handleItemTapped(selectedItem);
    }
  }
}
