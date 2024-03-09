import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game_challenge/catcher_game/background/background.dart';
import 'package:flutter_game_challenge/catcher_game/background/config.dart';
import 'package:flutter_game_challenge/catcher_game/common/config.dart';
import 'package:flutter_game_challenge/catcher_game/common/levels_config.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components.dart';
import 'package:flutter_game_challenge/common/entities/item_type.dart';

typedef CatchCallback = void Function(RecycleType dropType);

class MainScene extends PositionComponent
    with TapCallbacks, HasGameRef<CatcherGame> {
  MainScene({
    required this.onPauseResumeGameCallback,
    required this.onResetCallback,
  });

  final VoidCallback onPauseResumeGameCallback;
  final VoidCallback onResetCallback;
  final Map<ItemType, int> score = {};
  late List<Wave> waveList;
  bool isDestroy = false;
  bool isChangeWave = false;
  int currentWave = 0;
  int _spawned = 0;
  int _omissionsToShowTutorial = 0;
  bool _isHorizontalDragHandled = true;

  late Background _background;
  late BoxContainer _boxContainer;
  late DropContainer _dropContainer;
  late ButtonsContainer _buttonsContainer;
  late DropSpawner _dropSpawner;
  late WaveDelay _waveDelay;
  late TutorialContainer _tutorialContainer;

  @override
  FutureOr<void> onLoad() async {
    waveList = Levels.levels().first.waves;

    _background = Background(
      sprite: Sprite(game.images.fromCache(BackgroundConfig.sceneAsset)),
    );
    _boxContainer = BoxContainer();
    _buttonsContainer = ButtonsContainer(
      scene: this,
      onPauseOrPlayCallback: onPauseResumeGameCallback,
      onResetCallback: _handleResetCallback,
    );
    _waveDelay = WaveDelay(
      scene: this,
      duration: waveList[0].delay,
      onWaveFinished: () {
        _dropSpawner.start();
      },
    );

    _dropSpawner = DropSpawner(
      onSpawnerUpdate: _onNextSpawn,
      repeatNumber: waveList[currentWave].itemsInWave,
      ceilingTimeLimit: waveList[currentWave].maxDroppingInterval,
      floorTimeLimit: waveList[currentWave].minDroppingInterval,
    );

    _dropContainer = DropContainer(
      scene: this,
      catchCallback: _onCatch,
      boxContainer: _boxContainer,
      checkForWaveReset: _handleDropReset,
    );

    _tutorialContainer = TutorialContainer(scene: this);

    await addAll([
      _background,
      _boxContainer,
      _buttonsContainer,
      _dropSpawner,
      _waveDelay,
      _dropContainer,
      _tutorialContainer,
    ]);

    _initLevel();

    return super.onLoad();
  }

  @override
  void renderTree(Canvas canvas) {
    _background.render(canvas);
    _boxContainer.render(canvas);
    canvas
      ..save()
      ..clipRect(
        _boxContainer.boxClip(),
        clipOp: ClipOp.difference,
      );
    _dropContainer.render(canvas);
    canvas.restore();
    _buttonsContainer.render(canvas);
    _tutorialContainer.render(canvas);
  }

  @override
  void update(double dt) {
    if (game.status == CatcherGameStatus.playing) {
      super.update(dt);
    } else if (game.status == CatcherGameStatus.pause) {
      _buttonsContainer.update(dt);
    } else if (game.status == CatcherGameStatus.result) {
      _buttonsContainer.update(dt);
    } else if (game.status == CatcherGameStatus.tutorial) {
      _boxContainer.update(dt);
      _tutorialContainer.update(dt);
    }
  }

  @override
  void updateTree(double dt) {
    if (game.status == CatcherGameStatus.playing) {
      super.updateTree(dt);
    } else if (game.status == CatcherGameStatus.pause) {
      _buttonsContainer.updateTree(dt);
    } else if (game.status == CatcherGameStatus.result) {
      _buttonsContainer.updateTree(dt);
    } else if (game.status == CatcherGameStatus.tutorial) {
      _tutorialContainer.updateTree(dt);
    }
  }

  void onDragStart(DragStartDetails details) {
    if (game.status == CatcherGameStatus.playing) {
      if (_boxContainer.toRect().contains(details.localPosition)) {
        _boxContainer.handleDragStart();
        _isHorizontalDragHandled = false;
      }
    }
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (game.status == CatcherGameStatus.playing) {
      if (_boxContainer.toRect().contains(details.localPosition) &&
          !_isHorizontalDragHandled) {
        _boxContainer.handleDragUpdate(details);
      } else if (!_boxContainer.toRect().contains(details.localPosition) &&
          !_isHorizontalDragHandled) {
        onDragEnd(DragEndDetails());
      }
    }
  }

  void onDragEnd(DragEndDetails details) {
    if (game.status == CatcherGameStatus.playing) {
      if (!_isHorizontalDragHandled) {
        _boxContainer.handleDragEnd();
        _isHorizontalDragHandled = true;
      }
    }
  }

  void changeWave(int wave) {
    currentWave = wave;
    waveList = Levels.levels().first.waves;
    _dropSpawner
      ..stop()
      ..repeatNumber = waveList[currentWave].itemsInWave
      ..ceilingTimeLimit = waveList[currentWave].maxDroppingInterval
      ..floorTimeLimit = waveList[currentWave].minDroppingInterval;
    _waveDelay.reset(waveList[currentWave].delay);
    _spawned = waveList[currentWave].itemsInWave;
  }

  void _onNextSpawn() {
    _dropContainer.genDrop(
      speedMin: waveList[currentWave].minDroppingSpeed,
      speedMax: waveList[currentWave].maxDroppingSpeed,
      dropDiversityList: waveList[currentWave].dropDiversityList,
    );
  }

  void _onCatch(RecycleType dropType) {
    if (_boxContainer.chosenBoxType == dropType) {
      _boxContainer.handleCatch(isSuccessful: true);
      final currentScore = score[dropType.toItemType()] ?? 0;
      score[dropType.toItemType()] = currentScore + 1;
    } else {
      _omissionsToShowTutorial++;
      HapticFeedback.mediumImpact();
      _boxContainer.handleCatch(isSuccessful: false);
    }

    if (_omissionsToShowTutorial >=
        DebugBalancingTableConfig.maxOmissionsToShowTutorial) {
      _omissionsToShowTutorial = 1;
      _tutorialContainer.showTutorial();
    }

    --_spawned;
    if (_spawned == 0 && currentWave < waveList.length - 1) {
      _nextWave();
    }

    if (_spawned == 0 && currentWave == waveList.length - 1) {
      _showResultScreen();
    }
  }

  void _showResultScreen() {
    game.status = CatcherGameStatus.result;

    // TODO(viktor): here we probably should show dialog with the result
  }

  void _nextWave() {
    ++currentWave;

    changeWave(currentWave);
  }

  void _initLevel() {
    _waveDelay.start();
    _spawned = waveList[currentWave].itemsInWave;
    game.status = CatcherGameStatus.playing;
  }

  void _handleResetCallback() {
    _omissionsToShowTutorial = 0;
    _dropContainer.removeAll(_dropContainer.children);
    changeWave(0);
    onResetCallback();
  }

  void resumed() {
    _buttonsContainer.showPauseOverlay();
  }

  void _handleDropReset() {
    if (_dropSpawner.repeatNumber == 0) {
      _nextWave();
    }
  }
}
