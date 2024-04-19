import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/clicker_game/game_models/trash_type.dart';

import 'package:recyclo/clicker_game/overlays/widgets/target_category.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/finder_game/finder_game.dart';


class FinderHUD extends StatelessWidget {
  const FinderHUD({
    required this.game,
    required this.handleRightButton,
    super.key,
  });

  static const id = 'hud_overlay';

  final FinderGame game;
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
                child: RoundButton(
                  icon: Icons.keyboard_arrow_left,
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
                    clipBehavior: Clip.none,
                    children: List.generate(visibleItems.length, (index) {
                      final itemIndex = visibleItems.length - 1 - index;
                      final trashType = visibleItems[itemIndex];
                      return Positioned(
                        right: 10 + (itemIndex * -8.0),
                        child: Transform.scale(
                          scale: 1 - ((itemIndex * 5) / 100),
                          child: TargetCategories(
                            key: UniqueKey(),
                            animate: index == visibleItems.length - 1,
                            trashType: trashType,
                          ),
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
