import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/common.dart';

class TimerOverlay extends StatelessWidget {
  const TimerOverlay({super.key});

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
                    child: Text(
                      state.value.toString(),
                      style: context.textStyle(),
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
