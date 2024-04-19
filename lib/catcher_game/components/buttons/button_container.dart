import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_game_challenge/catcher_game/common/sprite_sheet_util.dart';
import 'package:flutter_game_challenge/catcher_game/common/visible_component.dart';
import 'package:flutter_game_challenge/catcher_game/components.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene.dart';
import 'package:flutter_game_challenge/common.dart';

enum ButtonType {
  reset,
  pausePlay,
}

class ButtonsContainer extends PositionComponent
    with TapCallbacks, HasGameRef<CatcherGame> {
  ButtonsContainer({
    required this.scene,
    required this.onPauseOrPlayCallback,
    required this.onResetCallback,
  });

  final MainScene scene;
  final VoidCallback onPauseOrPlayCallback;
  final VoidCallback onResetCallback;

  final Map<ButtonType, SpriteSheetUtil> _buttonsAssets =
      <ButtonType, SpriteSheetUtil>{};
  final List<ButtonAnimated> buttonList = <ButtonAnimated>[];

  late VisibleComponent _pauseOverlay;

  bool get isAnimationStarted => buttonList.any((button) => button.playing);

  @override
  void render(Canvas canvas) {
    for (final button in buttonList) {
      button.render(canvas);
    }
    _pauseOverlay.render(canvas);
  }

  @override
  FutureOr<void> onLoad() async {
    _fillAssetsContainer();

    for (final button in ButtonType.values) {
      final animation = _buttonsAssets[button]!.createAnimation(
        stepTime: ButtonsContainerConfig.buttonAnimationSpeed,
      );
      final itm = ButtonAnimated(
        animation: animation,
        buttonType: button,
        onFinishAnimation: _onFinishCallback(button),
      );

      buttonList.add(itm);
    }

    await addAll(buttonList);

    _pauseOverlay = VisibleComponent(
      sprite: Sprite(
        game.images.fromCache(
          Assets.images.catcher.button.play.path,
        ),
      ),
    );
    await add(_pauseOverlay);
  }

  @override
  //ignore: must_call_super, intended function override
  void onGameResize(Vector2 size) {
    if (isLoaded) {
      final tile = game.sizeConfig.tileSize;
      final gameSize = game.canvasSize.toSize();

      x = 0;
      y = gameSize.height -
          (tile * ButtonsContainerConfig.buttonsContainerPositionY);
      final buttonsSize = tile * ButtonsContainerConfig.buttonSize;

      for (final button in buttonList) {
        button
          ..height = buttonsSize * 2
          ..width = buttonsSize * 2
          ..y = y - (tile * 1.3);

        switch (button.buttonType) {
          case ButtonType.reset:
            button.x = gameSize.width / 2 + (buttonsSize * 1.05);
          case ButtonType.pausePlay:
            button.x = gameSize.width / 2 - (buttonsSize * 1.05);
        }
      }

      final overlayHook = buttonList
          .firstWhere((btn) => btn.buttonType == ButtonType.pausePlay);

      _pauseOverlay
        ..width = buttonsSize
        ..height = buttonsSize
        ..x = overlayHook.x
        ..y = overlayHook.y +
            buttonsSize / ButtonsContainerConfig.buttonPauseOverlayPositionY;

      super.onGameResize(size);
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) => switch (game.status) {
        CatcherGameStatusType.playing || CatcherGameStatusType.pause => true,
        _ => false,
      };

  @override
  void onTapDown(TapDownEvent event) {
    for (final button in buttonList) {
      if (button.tappingArea.contains(event.canvasPosition.toOffset()) &&
          button.isVisible) {
        if (button.buttonType == ButtonType.pausePlay) {
          if (game.status != CatcherGameStatusType.result) {
            onPauseOrPlayCallback();
            _pauseOverlay.isVisible = false;
            button.playing = true;
          }
        } else {
          button.playing = true;
        }
      }
    }
  }

  VoidCallback _onFinishCallback(ButtonType type) {
    VoidCallback callBack;
    switch (type) {
      case ButtonType.reset:
        callBack = onResetCallback;
      case ButtonType.pausePlay:
        callBack = showPauseOverlay;
    }
    return callBack;
  }

  void showPauseOverlay() {
    if (game.status == CatcherGameStatusType.pause &&
        !isAnimationStarted &&
        !_pauseOverlay.isVisible) {
      _pauseOverlay.isVisible = true;
    }
  }

  void _fillAssetsContainer() {
    for (final type in ButtonType.values) {
      switch (type) {
        case ButtonType.reset:
          _buttonsAssets[type] = SpriteSheetUtil(
            image: game.images
                .fromCache(Assets.images.catcher.animations.reset.path),
            textureWidth: ButtonsContainerConfig.animationFrameSize,
            textureHeight: ButtonsContainerConfig.animationFrameSize,
            columns: ButtonsContainerConfig.buttonAnimationRowsAndColumns,
            rows: ButtonsContainerConfig.buttonAnimationRowsAndColumns,
          );
        case ButtonType.pausePlay:
          _buttonsAssets[type] = SpriteSheetUtil(
            image: game.images
                .fromCache(Assets.images.catcher.animations.pause.path),
            textureWidth: ButtonsContainerConfig.animationFrameSize,
            textureHeight: ButtonsContainerConfig.animationFrameSize,
            columns: ButtonsContainerConfig.buttonAnimationRowsAndColumns,
            rows: ButtonsContainerConfig.buttonAnimationRowsAndColumns,
          );
      }
    }
  }
}
