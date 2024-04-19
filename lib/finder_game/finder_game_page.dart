import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/clicker_game/overlays/game_hud.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/finder_game/finder_game.dart';
import 'package:flutter_game_challenge/finder_game/finder_state.dart';
import 'package:flutter_game_challenge/finder_game/overlays/finder_hud.dart';
import 'package:flutter_game_challenge/finder_game/overlays/game_start_overlay.dart';
import 'package:flutter_game_challenge/service_provider.dart';

import '../trash_reserve/trash_reserve_repository.dart';

class FinderGamePage extends StatefulWidget {
  const FinderGamePage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => MultiBlocProvider(providers: [
        BlocProvider<TimerCubit>(
          create: (_) => ServiceProvider.get<TimerCubit>(),
        ),
        BlocProvider<TutorialCubit>(
          create: (_) => ServiceProvider.get<TutorialCubit>(),
        ),
      ], child: const FinderGamePage()),
    );
  }

  @override
  State<FinderGamePage> createState() => _FinderGamePageState();
}

class _FinderGamePageState extends State<FinderGamePage> {
  static const _maxGameWidth = 500.0;
  static const _maxGameHeight = 1100.0;

  late final FinderGame _game;

  @override
  void initState() {
    super.initState();
    _game = FinderGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterGameChallengeColors.landingBackground,
      body: BlocProvider<TimerCubit>(
        create: (_) => ServiceProvider.get<TimerCubit>(),
        child: BlocListener<TimerCubit, TimerState>(
          listener: (context, state) => _handleTimerState(
            context,
            state,
            _game.gameState,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Assets.images.cloudsBackground.image(fit: BoxFit.fill),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _maxGameWidth,
                    maxHeight: _maxGameHeight,
                  ),
                  child: GameWidget(
                    game: _game,
                    overlayBuilderMap: {
                      GameHUD.id: (_, FinderGame game) => FinderHUD(
                            game: game,
                            handleRightButton: _handleBackButton,
                          ),
                      GameStartOverlay.id: (context, __) => GameStartOverlay(
                            onPressed: () => _handleGameStart(context),
                          ),
                      TutorialOverlay.id: (context, __) => TutorialOverlay(
                            onBackButtonPressed: _handleBackButton,
                            onGameStart: () =>
                                _handleTutorialCompleted(context),
                          ),
                    },
                    backgroundBuilder: (context) => Container(
                      color: const Color(0xFF72A8CD),
                    ),
                    initialActiveOverlays: context
                            .read<TutorialCubit>()
                            .state
                            .isTutorialShownBefore
                        ? [
                            GameHUD.id,
                            GameStartOverlay.id,
                          ]
                        : [
                            GameHUD.id,
                            TutorialOverlay.id,
                          ],
                  ),
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

  void _handleGameStart(BuildContext context) {
    _game.overlays.remove(GameStartOverlay.id);
    context.read<TimerCubit>().start();
  }

  void _handleTimerState(
    BuildContext context,
    TimerState state,
    FinderState clickerState,
  ) {
    if (state == TimerFinishedState()) {
      final items = _game.gameState.generateCollectedResources();

      int _getTrashCountFor(ItemType type) {
        return items.firstWhereOrNull((trash) => trash.type == type)?.score ??
            0;
      }

      _game.pauseEngine();
      showGameFinishDialog(
        context: context,
        items: items,
        onDismiss: () {
          unawaited(ServiceProvider.get<TrashReserveRepository>().addResource(
            plastic: _getTrashCountFor(ItemType.plastic),
            paper: _getTrashCountFor(ItemType.paper),
            glass: _getTrashCountFor(ItemType.glass),
            organic: _getTrashCountFor(ItemType.organic),
            electronics: _getTrashCountFor(ItemType.electronic),
          ));
          Navigator.of(context).maybePop();
        },
      );
    }
  }

  void _handleTutorialCompleted(BuildContext context) {
    _game.overlays.remove(TutorialOverlay.id);
    context.read<TimerCubit>().start();
    context.read<TutorialCubit>().tutorialIsShown();
  }
}
