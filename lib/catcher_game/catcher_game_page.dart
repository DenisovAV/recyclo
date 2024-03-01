import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/service_provider.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';

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
  CatcherGame? _game;

  static const _maxGameWidth = 500.0;
  static const _maxGameHeight = 1100.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _game ??= CatcherGame();

    return Scaffold(
      backgroundColor: FlutterGameChallengeColors.landingBackground,
      body: BlocProvider<TimerCubit>(
        create: (_) => ServiceProvider.get<TimerCubit>(),
        child: BlocListener<TimerCubit, TimerState>(
          listener: _handleTimerState,
          child: LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Assets.images.cloudsBackground.image(fit: BoxFit.fill),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth > _maxGameWidth
                          ? _maxGameWidth
                          : constraints.maxWidth,
                      maxHeight: constraints.maxHeight > _maxGameHeight
                          ? _maxGameHeight
                          : constraints.maxHeight,
                    ),
                    child: Material(
                      elevation: 9,
                      child: GameWidget(
                        game: _game!,
                        overlayBuilderMap: {
                          CatcherGame.timerOverlayKey: (_, __) =>
                              const TimerOverlay(),
                        },
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundButton(
                          icon: Icons.keyboard_arrow_left,
                          onPressed: _handleBackButton,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
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

      final playerScore = _game!.getPlayerScore();

      showGameFinishDialog(
        context: context,
        items: playerScore,
        onDismiss: () {
          unawaited(ServiceProvider.get<TrashReserveRepository>().addResource(
            plastic: playerScore.getPlayerScore(ItemType.plastic),
            paper: playerScore.getPlayerScore(ItemType.paper),
            glass: playerScore.getPlayerScore(ItemType.glass),
            organic: playerScore.getPlayerScore(ItemType.organic),
            electronics: playerScore.getPlayerScore(ItemType.electronic),
          ));
          Navigator.of(context).maybePop();
        },
      );
    }
  }
}

extension on List<({ItemType type, int score})> {
  int getPlayerScore(ItemType type) {
    if (isEmpty) {
      return 0;
    }

    return firstWhereOrNull((scoreRecord) => scoreRecord.type == type)?.score ??
        0;
  }
}
