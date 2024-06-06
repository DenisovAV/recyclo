import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/catcher_game/common/size_config.dart';
import 'package:recyclo/catcher_game/components.dart';
import 'package:recyclo/catcher_game/main_scene.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/service_provider.dart';

typedef UpdateStatusCallback = void Function(CatcherGameStatusType status);
typedef WaveCallback = void Function(int value);
typedef LevelCallback = void Function(int level);

class CatcherGame extends FlameGame with TapCallbacks, HorizontalDragDetector, KeyboardEvents {
  CatcherGame({
    bool? isPenaltyEnabled,
    AccessibilityGameScaleType? gameScaleType,
    GameDifficultyType? gameDifficultyType,
  })  : isPenaltyEnabled = isPenaltyEnabled ?? true,
        status = CatcherGameStatusType.playing,
        scaleType = gameScaleType ?? AccessibilityGameScaleType.small,
        difficultyType = gameDifficultyType ?? GameDifficultyType.easy;

  final AccessibilityGameScaleType scaleType;
  final GameDifficultyType difficultyType;
  final bool isPenaltyEnabled;

  late SizeConfig sizeConfig;

  // TODO(vikrech): replace this property with a game cubit, and subscribe to its state in children.
  late CatcherGameStatusType status;
  MainScene? mainScene;
  bool _timerStarted = false;
  double _currentLocalPosition = 0.0;

  @override
  FutureOr<void> onLoad() async {
    sizeConfig = SizeConfig(scaleType);
    await add(sizeConfig);

    mainScene = MainScene(
      onPauseResumeGameCallback: _handlePauseResumeGameCallback,
      onResetCallback: _handleOnResetCallback,
      assetsByItemTypeCallback: ServiceProvider.get<AssetsLoader>().getAssetsListByItemType,
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
    mainScene?.onDragEnd();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;
    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isSpace) {
      _switchBetweenPauseAndPlaying();
      return KeyEventResult.handled;
    }

    if (isKeyDown) {
      if (isLeft || isRight) {
        final details = DragStartDetails(
          localPosition: Offset(_currentLocalPosition, 0.0),
        );
        handleHorizontalDragStart(details);
      }
      if (isLeft) {
        final updateDetails = DragUpdateDetails(
          globalPosition: Offset.zero,
          localPosition: Offset(_currentLocalPosition, 0.0),
          delta: const Offset(100, 0.0),
        );
        _currentLocalPosition = _currentLocalPosition + 100;
        mainScene?.onKeyBoardTap(updateDetails);

        return KeyEventResult.handled;
      }
      if (isRight) {
        final updatedDetails = DragUpdateDetails(
          globalPosition: Offset.zero,
          localPosition: Offset(_currentLocalPosition, 0.0),
          delta: const Offset(-100, 0.0),
        );
        _currentLocalPosition = _currentLocalPosition - 100;
        mainScene?.onKeyBoardTap(updatedDetails);

        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  void _switchBetweenPauseAndPlaying() {
    if (status == CatcherGameStatusType.playing) {
      _pauseGame();
    } else if (status == CatcherGameStatusType.pause) {
      _resumeGame();
    }
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
