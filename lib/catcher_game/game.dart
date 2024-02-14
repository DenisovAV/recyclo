import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/catcher_game/common.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/main_scene.dart';

enum CatcherGameStatus { playing, pause, result, tutorial }

typedef UpdateStatusCallback = void Function(CatcherGameStatus status);
typedef WaveCallback = void Function(int value);
typedef LevelCallback = void Function(int level);

class CatcherGame extends FlameGame with TapCallbacks, HorizontalDragDetector {
  CatcherGame() : status = CatcherGameStatus.playing;

  late SizeConfig sizeConfig;
  late CatcherGameStatus status;
  MainScene? mainScene;

  @override
  FutureOr<void> onLoad() async {
    sizeConfig = SizeConfig();
    await add(sizeConfig);

    mainScene = MainScene(
      onPauseResumeGameCallback: _handlePauseResumeGameCallback,
    );

    await add(mainScene!);
    return super.onLoad();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _pauseGame();
    } else if (state == AppLifecycleState.resumed) {
      mainScene?.resumed();
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
  }

  void _resumeGame() {
    status = CatcherGameStatus.playing;
  }

  void _handlePauseResumeGameCallback() {
    if (status == CatcherGameStatus.pause) {
      _resumeGame();
    } else {
      _pauseGame();
    }
  }
}
