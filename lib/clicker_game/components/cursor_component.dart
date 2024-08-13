import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:recyclo/clicker_game/clicker_game.dart';


class CursorComponent extends PositionComponent with KeyboardHandler, HasGameRef<ClickerGame> {
  CursorComponent({
    required Vector2 position,
    required this.onPositionChanged,
    required this.onItemSelected,
    this.speed = 5,
  }) : super(
          position: position,
          size:  Vector2(50, 50),
          anchor: Anchor.center,
        );

  final double speed;
  final void Function(Vector2) onPositionChanged;
  final VoidCallback onItemSelected;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(size.toRect(), paint);
  }


  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.arrowUp) {
        position.y -= speed;
      } else if (key == LogicalKeyboardKey.arrowDown) {
        position.y += speed;
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        position.x -= speed;
      } else if (key == LogicalKeyboardKey.arrowRight) {
        position.x += speed;
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
    final selectedItem = game.gameState.trashItems.value
        .firstWhereOrNull((item) => item.containsPoint(position));
    if (selectedItem != null) {
      game.handleItemTapped(selectedItem);
    }
  }
}