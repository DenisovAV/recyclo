import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/common.dart';

class TimerOverlay extends StatelessWidget {
  const TimerOverlay({super.key});

  static const String id = 'timer_overlay';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        return switch (state) {
          TimerStateWithValue() => SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        state.value.toString(),
                        style: context.textStyle(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
