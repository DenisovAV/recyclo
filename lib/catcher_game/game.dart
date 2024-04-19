import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/catcher_game/common/size_config.dart';
import 'package:recyclo/catcher_game/main_scene.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/service_provider.dart';

typedef UpdateStatusCallback = void Function(CatcherGameStatusType status);
typedef WaveCallback = void Function(int value);
typedef LevelCallback = void Function(int level);

class CatcherGame extends FlameGame with TapCallbacks, HorizontalDragDetector {
  CatcherGame({
    AccessibilityGameScaleType? gameScaleType,
    GameDifficultyType? gameDifficultyType,
  })  : status = CatcherGameStatusType.playing,
        scaleType = gameScaleType ?? AccessibilityGameScaleType.small,
        difficultyType = gameDifficultyType ?? GameDifficultyType.easy;

  final AccessibilityGameScaleType scaleType;
  final GameDifficultyType difficultyType;
  late SizeConfig sizeConfig;
  late CatcherGameStatusType status;
  MainScene? mainScene;
  bool _timerStarted = false;

  @override
  FutureOr<void> onLoad() async {
    sizeConfig = SizeConfig(scaleType);
    await add(sizeConfig);

    mainScene = MainScene(
      onPauseResumeGameCallback: _handlePauseResumeGameCallback,
      onResetCallback: _handleOnResetCallback,
      assetsByItemTypeCallback:
          ServiceProvider.get<AssetsLoader>().getAssetsListByItemType,
    );

    await add(mainScene!);
    overlays.add(TimerOverlay.id);
    return super.onLoad();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (isAttached) {
      if (state == AppLifecycleState.inactive) {
        _pauseGame();
      } else if (state == AppLifecycleState.resumed) {
        mainScene?.resumed();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_timerStarted && isAttached) {
      _timerStarted = true;
      BlocProvider.of<TimerCubit>(buildContext!).start();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    mainScene?.onTapDown(event);
  }

  @override
  void handleHorizontalDragStart(DragStartDetails details) {
    mainScene?.onDragStart(details);
  }

  @override
  void handleHorizontalDragUpdate(DragUpdateDetails details) {
    mainScene?.onDragUpdate(details);
  }

  @override
  void handleHorizontalDragEnd(DragEndDetails details) {
    mainScene?.onDragEnd(details);
  }

  void _pauseGame() {
    if (status == CatcherGameStatusType.playing) {
      status = CatcherGameStatusType.pause;
    }
    if (isAttached) {
      BlocProvider.of<TimerCubit>(buildContext!).pause();
    }
  }

  void _resumeGame() {
    status = CatcherGameStatusType.playing;
    if (isAttached) {
      BlocProvider.of<TimerCubit>(buildContext!).resume();
    }
  }

  void _handlePauseResumeGameCallback() {
    if (status == CatcherGameStatusType.pause) {
      _resumeGame();
    } else {
      _pauseGame();
    }
  }

  void _handleOnResetCallback() {
    if (status == CatcherGameStatusType.pause) {
      BlocProvider.of<TimerCubit>(buildContext!).restart();
    } else {
      BlocProvider.of<TimerCubit>(buildContext!).start();
      overlays.remove(
        TimerReductionOrIncrementEffect.idIncrement,
      );
    }
  }

  List<({ItemType type, int score})> getPlayerScore() {
    if (mainScene == null) {
      return [];
    }

    final score = mainScene!.score;

    if (score.isEmpty) {
      return [];
    }

    return score.entries
        .map(
          (entry) => (
            type: entry.key,
            score: entry.value,
          ),
        )
        .toList();
  }
}
