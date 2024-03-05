import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/clicker_game/clicker_game.dart';
import 'package:flutter_game_challenge/clicker_game/game_state.dart';
import 'package:flutter_game_challenge/clicker_game/overlays/game_hud.dart';
import 'package:flutter_game_challenge/clicker_game/overlays/game_start_overlay.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/service_provider.dart';

import '../trash_reserve/trash_reserve_repository.dart';
import 'overlays/timer_reduction_effect.dart';

class ClickerGamePage extends StatefulWidget {
  const ClickerGamePage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ClickerGamePage(),
    );
  }

  @override
  State<ClickerGamePage> createState() => _ClickerGamePageState();
}

class _ClickerGamePageState extends State<ClickerGamePage> {
  late final ClickerGame _game;

  @override
  void initState() {
    super.initState();
    _game = ClickerGame(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<TimerCubit>(
        create: (_) => ServiceProvider.get<TimerCubit>(),
        child: BlocListener<TimerCubit, TimerState>(
          listener: (context, state) => _handleTimerState(
            context,
            state,
            _game.gameState,
          ),
          child: GameWidget(
            game: _game,
            overlayBuilderMap: {
              GameHUD.id: (_, ClickerGame game) => GameHUD(
                    game: game,
                    handleRightButton: _handleBackButton,
                  ),
              GameStartOverlay.id: (context, __) => GameStartOverlay(
                    onPressed: () => _handleGameStart(context),
                  ),
              TimerReductionEffect.id: (context, __) => TimerReductionEffect(
                    text: '-5',
                    onAnimationEnded: () {
                      context.read<TimerCubit>().penalty = 5;
                      _game.overlays.remove(TimerReductionEffect.id);
                    },
                  ),
            },
            backgroundBuilder: (context) => Container(
              // color: FlutterGameChallengeColors.blueSky,
              color: const Color(0xFF72A8CD),
            ),
            initialActiveOverlays: const [
              GameHUD.id,
              GameStartOverlay.id,
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
    context.read<TimerCubit>().play();
  }

  void _handleTimerState(
    BuildContext context,
    TimerState state,
    ClickerState clickerState,
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
}
