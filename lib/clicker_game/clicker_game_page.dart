import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/clicker_game/clicker_game.dart';
import 'package:recyclo/clicker_game/game_state.dart';
import 'package:recyclo/clicker_game/overlays/game_hud.dart';
import 'package:recyclo/clicker_game/overlays/game_start_overlay.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/service_provider.dart';
import 'package:recyclo/settings/persistence/settings_persistence.dart';

import '../trash_reserve/trash_reserve_repository.dart';
import 'overlays/timer_reduction_effect.dart';

class ClickerGamePage extends StatefulWidget {
  const ClickerGamePage({
    super.key,
    required this.settingsPersistence,
  });

  final SettingsPersistence settingsPersistence;

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
        child: Scaffold(
          backgroundColor: const Color(0xFF72A8CD),
          body: ClickerGamePage(
            settingsPersistence: ServiceProvider.get(),
          ),
        ),
      ),
    );
  }

  @override
  State<ClickerGamePage> createState() => _ClickerGamePageState();
}

class _ClickerGamePageState extends State<ClickerGamePage> {
  late final ClickerGame _game;

  static const _maxGameWidth = 500.0;
  static const _maxGameHeight = 1100.0;

  @override
  void initState() {
    super.initState();
    _game = ClickerGame(
      context: context,
      settingsPersistence: widget.settingsPersistence,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerCubit, TimerState>(
      listener: (context, state) => _handleTimerState(
        context,
        state,
        _game.gameState,
      ),
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
                  clipBehavior: Clip.hardEdge,
                  child: GameWidget(
                    game: _game,
                    overlayBuilderMap: _clickerOverlayBuilder,
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
            ),
          ],
        );
      }),
    );
  }

  Map<String, Widget Function(BuildContext, ClickerGame)>
      get _clickerOverlayBuilder {
    return {
      GameHUD.id: (BuildContext context, ClickerGame game) => GameHUD(
            game: game,
            handleRightButton: _handleBackButton,
          ),
      GameStartOverlay.id: (BuildContext context, ClickerGame game) =>
          GameStartOverlay(
            onPressed: () => _handleGameStart(context),
          ),
      TimerReductionOrIncrementEffect.idReduction: (BuildContext context, ClickerGame game) =>
          TimerReductionEffect(
            text: '-5',
            onAnimationEnded: () async {
              final isPenaltyEnbled =
                  widget.settingsPersistence.getPenaltyFlag();

              if (isPenaltyEnbled) {
                context.read<TimerCubit>().penalty = 5;
              }
              _game.overlays.remove(TimerReductionOrIncrementEffect.idReduction);
            },
          ),
      TutorialOverlay.id: (BuildContext context, ClickerGame game) =>
          TutorialOverlay(
            onBackButtonPressed: _handleBackButton,
            onGameStart: () => _handleTutorialCompleted(context),
          ),
    };
  }

  void _handleBackButton() {
    Navigator.of(context).pop();
  }

  void _handleGameStart(BuildContext context) {
    _game.overlays.remove(GameStartOverlay.id);
    context.read<TimerCubit>().start();
  }

  void _handleTutorialCompleted(BuildContext context) {
    _game.overlays.remove(TutorialOverlay.id);
    context.read<TimerCubit>().start();
    context.read<TutorialCubit>().tutorialIsShown();
  }

  void _handleTimerState(
    BuildContext context,
    TimerState state,
    ClickerState clickerState,
  ) {
    if (state == TimerFinishedState()) {
      final items = _game.gameState.generateCollectedResources();

      int getTrashCountFor(ItemType type) {
        return items.firstWhereOrNull((trash) => trash.type == type)?.score ??
            0;
      }

      _game.pauseEngine();
      showGameFinishDialog(
        context: context,
        items: items,
        onDismiss: () {
          unawaited(
            ServiceProvider.get<TrashReserveRepository>().addResource(
              plastic: getTrashCountFor(ItemType.plastic),
              paper: getTrashCountFor(ItemType.paper),
              glass: getTrashCountFor(ItemType.glass),
              organic: getTrashCountFor(ItemType.organic),
              electronics: getTrashCountFor(ItemType.electronic),
            ),
          );
          Navigator.of(context).maybePop();
        },
      );
    }
  }
}
