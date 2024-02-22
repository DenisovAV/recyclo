import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/menu/view/main_menu_page.dart';
import 'package:flutter_game_challenge/service_provider.dart';

class CatcherGamePage extends StatefulWidget {
  const CatcherGamePage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CatcherGamePage(),
    );
  }

  @override
  State<CatcherGamePage> createState() => _CatcherGamePageState();
}

class _CatcherGamePageState extends State<CatcherGamePage> {
  FlameGame? _game;

  @override
  Widget build(BuildContext context) {
    _game ??= CatcherGame();

    return Scaffold(
      body: BlocProvider<TimerCubit>(
        create: (_) => ServiceProvider.get<TimerCubit>(),
        child: BlocListener<TimerCubit, TimerState>(
          listener: _handleTimerState,
          child: Stack(
            children: [
              GameWidget(
                game: _game!,
                overlayBuilderMap: {
                  CatcherGame.timerOverlayKey: (_, __) => const TimerOverlay(),
                },
              ),
              SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: GameBackButton(
                        onPressed: _handleBackButton,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBackButton() {
    Navigator.of(context).pop();
  }

  void _handleTimerState(BuildContext context, TimerState state) {
    if (state == TimerFinishedState()) {
      _game?.pauseEngine();
      showGameFinishDialog(
        context: context,
        items: [
          (ItemType.plastic, 1),
          (ItemType.paper, 1),
          (ItemType.glass, 1),
        ],
        onDismiss: () {
          Navigator.of(context).maybePop();
        },
      );
    }
  }
}
