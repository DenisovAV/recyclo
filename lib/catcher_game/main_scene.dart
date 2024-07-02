import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recyclo/catcher_game/common/config.dart';
import 'package:recyclo/catcher_game/common/levels_config.dart';
import 'package:recyclo/catcher_game/components.dart';
import 'package:recyclo/catcher_game/game.dart';
import 'package:recyclo/catcher_game/game_models.dart';
import 'package:recyclo/common.dart';

typedef CatchCallback = void Function(ItemType dropType);

class MainScene extends PositionComponent
    with TapCallbacks, HasGameRef<CatcherGame> {
  MainScene({
    required this.onPauseResumeGameCallback,
    required this.onResetCallback,
    required this.assetsByItemTypeCallback,
  });

  final VoidCallback onPauseResumeGameCallback;
  final VoidCallback onResetCallback;
  final AssetsByItemTypeCallback assetsByItemTypeCallback;
  final Map<ItemType, int> score = {};

  late List<Wave> waveList;
  late Background background;
  late BoxContainer _boxContainer;
  late DropContainer _dropContainer;
  late ButtonsContainer _buttonsContainer;
  late DropSpawner _dropSpawner;
  late TutorialContainer _tutorialContainer;

  int currentWave = 0;
  int spawned = 0;
  int? _currentWaveItems;
  int _omissionsToShowTutorial = 0;
  bool isChangeWave = false;
  bool _isHorizontalDragHandled = true;

  @override
  FutureOr<void> onLoad() async {
    waveList = Levels.levels(game.difficultyType).first.waves;

    background = Background(
      sprite: Sprite(game.images.fromCache(Assets.images.catcher.bg.bg.path)),
    );
    _boxContainer = BoxContainer();
    _buttonsContainer = ButtonsContainer(
      scene: this,
      onPauseOrPlayCallback: onPauseResumeGameCallback,
      onResetCallback: _handleResetCallback,
    );

    _dropSpawner = DropSpawner(
      onNextSpawnCallback: _handleOnNextSpawnCallback,
      repeatNumber: waveList[currentWave].itemsInWave,
      ceilingTimeLimit: waveList[currentWave].maxDroppingInterval,
      floorTimeLimit: waveList[currentWave].minDroppingInterval,
    );

    _dropContainer = DropContainer(
      scene: this,
      catchCallback: _onCatch,
      boxContainer: _boxContainer,
      checkForWaveReset: _handleDropReset,
      assetsByItemTypeCallback: assetsByItemTypeCallback,
    );

    _tutorialContainer = TutorialContainer(scene: this);

    await addAll([
      background,
      _boxContainer,
      _buttonsContainer,
      _dropSpawner,
      _dropContainer,
      _tutorialContainer,
    ]);

    changeWave(0);
    game.status = CatcherGameStatusType.playing;

    return super.onLoad();
  }

  @override
  void renderTree(Canvas canvas) {
    background.render(canvas);
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
    if (game.status == CatcherGameStatusType.playing) {
      super.update(dt);
    } else if (game.status == CatcherGameStatusType.pause) {
      _buttonsContainer.update(dt);
    } else if (game.status == CatcherGameStatusType.result) {
      _buttonsContainer.update(dt);
    } else if (game.status == CatcherGameStatusType.tutorial) {
      _boxContainer.update(dt);
      _tutorialContainer.update(dt);
    }
  }

  void onDragStart(DragStartDetails details) {
    if (game.status == CatcherGameStatusType.playing) {
      if (_boxContainer.toRect().contains(details.localPosition)) {
        _boxContainer.handleDragStart();
        _isHorizontalDragHandled = false;
      }
    }
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (game.status == CatcherGameStatusType.playing) {
      if (_boxContainer.toRect().contains(details.localPosition) &&
          !_isHorizontalDragHandled) {
        _boxContainer.handleDragUpdate(details);
      } else if (!_boxContainer.toRect().contains(details.localPosition) &&
          !_isHorizontalDragHandled) {
        onDragEnd();
      }
    }
  }

  void onKeyBoardTap(DragUpdateDetails details) {
    _boxContainer.handleDragUpdate(details);
    _isHorizontalDragHandled = false;
    onDragEnd();
  }

  void onEnterTap() {
    if(game.status == CatcherGameStatusType.tutorial) {
      _tutorialContainer.onHideTutorial();
    }
  }

  void onDragEnd() {
    if (game.status == CatcherGameStatusType.playing) {
      if (!_isHorizontalDragHandled) {
        _boxContainer.handleDragEnd();
        _isHorizontalDragHandled = true;
      }
    }
  }

  void changeWave(int wave) {
    _currentWaveItems = waveList[wave].itemsInWave;
    currentWave = wave;
    waveList = Levels.levels(game.difficultyType).first.waves;
    _dropSpawner
      ..stop()
      ..start()
      ..repeatNumber = waveList[currentWave].itemsInWave
      ..ceilingTimeLimit = waveList[currentWave].maxDroppingInterval
      ..floorTimeLimit = waveList[currentWave].minDroppingInterval;
  }

  void resumed() {
    _buttonsContainer.showPauseOverlay();
  }

  void _handleOnNextSpawnCallback() {
    ++spawned;
    _dropContainer.genDrop(
      speedMin: waveList[currentWave].minDroppingSpeed,
      speedMax: waveList[currentWave].maxDroppingSpeed,
      dropDiversityList: waveList[currentWave].dropDiversityList,
    );
  }

  void _onCatch(ItemType dropType) {
    if (_boxContainer.chosenBoxType == dropType) {
      _boxContainer.handleCatch(isSuccessful: true);
      final currentScore = score[dropType] ?? 0;
      score[dropType] = currentScore + 1;
      game.overlays.add(TimerReductionOrIncrementEffect.idIncrement);
    } else {
      if (game.isPenaltyEnabled) {
        game.overlays.add(TimerReductionOrIncrementEffect.idReduction);
      }

      _omissionsToShowTutorial++;
      HapticFeedback.mediumImpact();
      _boxContainer.handleCatch(isSuccessful: false);
    }

    if (_omissionsToShowTutorial >=
        DebugBalancingTableConfig.maxOmissionsToShowTutorial) {
      _omissionsToShowTutorial = 1;
      _tutorialContainer.showTutorial();
    }

    if (_currentWaveItems != null) {
      _currentWaveItems = _currentWaveItems! - 1;
    }

    if (_currentWaveItems != null && _currentWaveItems! <= 0) {
      _nextWave();
    }
  }

  void _nextWave() {
    ++currentWave;

    changeWave(currentWave);
  }

  void _handleResetCallback() {
    _omissionsToShowTutorial = 0;
    _dropContainer.removeAll(_dropContainer.children);
    changeWave(0);
    onResetCallback();
    _dropSpawner.start();
    spawned = 0;
  }

  void _handleDropReset() {
    if (_dropSpawner.repeatNumber == 0) {
      _nextWave();
    }
  }
}
