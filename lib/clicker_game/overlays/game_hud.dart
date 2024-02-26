import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_game_challenge/clicker_game/clicker_game.dart';
import 'package:flutter_game_challenge/clicker_game/game_models/trash_item.dart';
import 'package:flutter_game_challenge/common.dart';

import 'package:flutter_game_challenge/menu/view/main_menu_page.dart';

class GameHUD extends StatelessWidget {
  const GameHUD({
    required this.game,
    required this.handleRightButton,
    super.key,
  });

  static const id = 'hud_overlay';

  final ClickerGame game;
  final VoidCallback handleRightButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: GameBackButton(
                  onPressed: handleRightButton,
                ),
              ),
            ),
             Flexible(
              flex: 4,
              child: Center(
                child: BlocBuilder<TimerCubit, TimerState>(
                  builder: (context, state) {
                    return switch (state) {
                      TimerStateWithValue() => Text(
                        state.value.toString(),
                        textAlign: TextAlign.center,
                        style: context.textStyle(),
                      ),
                      _ => const SizedBox.shrink(),
                    };
                  },
                ),
              ),
            ),
            Flexible(
              child: ValueListenableBuilder<List<TrashType>>(
                valueListenable: game.gameState.currentTargetTypes,
                builder: (context, targetTypes, widget) {
                  final visibleItems = targetTypes.reversed.take(5).toList();
                  return Stack(
                    alignment: Alignment.centerRight,
                    children: List.generate(visibleItems.length, (index) {
                      final itemIndex = visibleItems.length - 1 - index;
                      final trashType = visibleItems[itemIndex];
                      return Positioned(
                        right: 10 + (itemIndex * -8.0),
                        child: TargetCategories(
                          itemIndex: itemIndex,
                          trashType: trashType,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TargetCategories extends StatelessWidget {
  const TargetCategories({
    required this.itemIndex,
    required this.trashType,
    super.key,
  });

  final int itemIndex;
  final TrashType trashType;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      scale: 1 - ((itemIndex * 3) / 100),
      child: SizedBox.square(
        dimension: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trashType.color,
            border: Border.all(
              color: const Color(0xFF4D3356),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Image.asset(
                trashType.iconPath,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
