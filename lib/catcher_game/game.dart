import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/catcher_game/common/size_config.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/service_provider.dart';

enum CatcherGameStatus { playing, pause, result, tutorial }

typedef UpdateStatusCallback = void Function(CatcherGameStatus status);
typedef WaveCallback = void Function(int value);
typedef LevelCallback = void Function(int level);

class CatcherGame extends FlameGame with TapCallbacks, HorizontalDragDetector {
  CatcherGame() : status = CatcherGameStatus.playing;

  late SizeConfig sizeConfig;
  late CatcherGameStatus status;
  MainScene? mainScene;
  bool _timerStarted = false;

  static const String timerOverlayKey = 'timer';

  @override
  FutureOr<void> onLoad() async {
    sizeConfig = SizeConfig();
    await add(sizeConfig);

    mainScene = MainScene(
      onPauseResumeGameCallback: _handlePauseResumeGameCallback,
      onResetCallback: _handleOnResetCallback,
      assetsByItemTypeCallback:
          ServiceProvider.get<AssetsLoader>().getAssetsListByItemType,
    );

    await add(mainScene!);
    overlays.add(timerOverlayKey);
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
    if (status == CatcherGameStatus.playing) {
      status = CatcherGameStatus.pause;
    }
    if (isAttached) {
      BlocProvider.of<TimerCubit>(buildContext!).pause();
    }
  }

  void _resumeGame() {
    status = CatcherGameStatus.playing;
    if (isAttached) {
      BlocProvider.of<TimerCubit>(buildContext!).play();
    }
  }

  void _handlePauseResumeGameCallback() {
    if (status == CatcherGameStatus.pause) {
      _resumeGame();
    } else {
      _pauseGame();
    }
  }

  void _handleOnResetCallback() {
    if (status == CatcherGameStatus.pause) {
      BlocProvider.of<TimerCubit>(buildContext!).restart();
    } else {
      BlocProvider.of<TimerCubit>(buildContext!)
        ..restart()
        ..start();
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
