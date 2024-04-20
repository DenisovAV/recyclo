import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/catcher_game/game.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/service_provider.dart';
import 'package:recyclo/settings/persistence/settings_persistence.dart';
import 'package:recyclo/trash_reserve/trash_reserve_repository.dart';

class CatcherGamePage extends StatefulWidget {
  const CatcherGamePage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<TimerCubit>(
            create: (_) => ServiceProvider.get<TimerCubit>(),
          ),
          BlocProvider<TutorialCubit>(
            create: (_) => ServiceProvider.get<TutorialCubit>(),
          ),
        ],
        child: const CatcherGamePage(),
      ),
    );
  }

  @override
  State<CatcherGamePage> createState() => _CatcherGamePageState();
}

class _CatcherGamePageState extends State<CatcherGamePage> {
  CatcherGame? _game;
  late SettingsPersistence settingsPersistence;

  static const _maxGameWidth = 500.0;
  static const _maxGameHeight = 1100.0;

  @override
  void initState() {
    settingsPersistence = ServiceProvider.get<SettingsPersistence>();
    print(settingsPersistence.getGameDifficulty(
      defaultValue: GameDifficultyType.easy,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _game ??= CatcherGame(
      gameDifficultyType: settingsPersistence.getGameDifficulty(
        defaultValue: GameDifficultyType.easy,
      ),
      isPenaltyEnabled: settingsPersistence.getPenaltyFlag(),
    );

    return Scaffold(
      backgroundColor: FlutterGameChallengeColors.landingBackground,
      body: BlocBuilder<TutorialCubit, TutorialState>(
        builder: (context, state) {
          return state.isTutorialShown
              ? BlocListener<TimerCubit, TimerState>(
                  listener: _handleTimerState,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Semantics(
                              image: true,
                              excludeSemantics: true,
                              label: context.l10n.tutorialDescription,
                              child: Assets.images.cloudsBackground
                                  .image(fit: BoxFit.fill),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth > _maxGameWidth
                                    ? _maxGameWidth
                                    : constraints.maxWidth,
                                maxHeight:
                                    constraints.maxHeight > _maxGameHeight
                                        ? _maxGameHeight
                                        : constraints.maxHeight,
                              ),
                              child: Material(
                                elevation: 9,
                                child: GameWidget(
                                  game: _game!,
                                  overlayBuilderMap: {
                                    TimerOverlay.id: (_, __) =>
                                        const TimerOverlay(),
                                    TimerReductionOrIncrementEffect.idIncrement:
                                        (_, __) =>
                                            TimerReductionOrIncrementEffect(
                                              text: '+5',
                                              onAnimationEnded:
                                                  _handleTimerIncrementEffectAnimationEnd,
                                            ),
                                    TimerReductionOrIncrementEffect.idReduction:
                                        (_, __) =>
                                            TimerReductionOrIncrementEffect(
                                              text: '-5',
                                              onAnimationEnded:
                                                  _handleTimerReductionEffectAnimationEnd,
                                            ),
                                  },
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RoundButton(
                                    semanticsLabel:
                                        context.l10n.backButtonLabel,
                                    icon: Icons.keyboard_arrow_left,
                                    onPressed: _handleBackButton,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : TutorialOverlay(
                  onBackButtonPressed: _handleBackButton,
                  onGameStart: _handleTutorialCompleted,
                );
        },
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
          unawaited(
            ServiceProvider.get<TrashReserveRepository>().addResource(
              plastic: playerScore.getPlayerScore(ItemType.plastic),
              paper: playerScore.getPlayerScore(ItemType.paper),
              glass: playerScore.getPlayerScore(ItemType.glass),
              organic: playerScore.getPlayerScore(ItemType.organic),
              electronics: playerScore.getPlayerScore(ItemType.electronic),
            ),
          );
          Navigator.of(context).maybePop();
        },
      );
    }
  }

  void _handleTutorialCompleted() {
    context.read<TutorialCubit>().tutorialIsShown();
  }

  void _handleTimerIncrementEffectAnimationEnd() {
    context.read<TimerCubit>().increaseTime(seconds: 5);
    _game!.overlays.remove(
      TimerReductionOrIncrementEffect.idIncrement,
    );
  }

  void _handleTimerReductionEffectAnimationEnd() {
    context.read<TimerCubit>().decreaseTime(seconds: 5);
    _game!.overlays.remove(
      TimerReductionOrIncrementEffect.idReduction,
    );
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
