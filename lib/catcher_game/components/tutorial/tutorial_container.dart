import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:recyclo/catcher_game/common/visible_component.dart';
import 'package:recyclo/catcher_game/components.dart';
import 'package:recyclo/catcher_game/game.dart';
import 'package:recyclo/catcher_game/main_scene.dart';
import 'package:recyclo/common.dart';

class TutorialContainer extends PositionComponent
    with HasGameRef<CatcherGame>, TapCallbacks {
  TutorialContainer({
    required this.scene,
  });

  final MainScene scene;

  late final VisibleComponent _tutorialBackground;
  late final SolidBackground _resultBackgroundComponent;
  late final VisibleComponent _buttonComponent;

  @override
  FutureOr<void> onLoad() async {
    _resultBackgroundComponent =
        SolidBackground.withAlpha(TutorialContainerConfig.backgroundAlpha);

    _buttonComponent = VisibleComponent(
      sprite: Sprite(
        game.images.fromCache(
          Assets.images.catcher.tutorial.play.path,
        ),
      ),
    );

    _tutorialBackground = VisibleComponent(
      anchor: Anchor.bottomCenter,
      sprite: Sprite(
        game.images.fromCache(
          Assets.images.catcher.tutorial.tutorial.path,
        ),
      ),
    );

    await addAll([
      _resultBackgroundComponent,
      _tutorialBackground,
      _buttonComponent,
    ]);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    if (isLoaded) {
      final newSize = size.toSize();
      final tile = game.sizeConfig.tileSize;

      x = newSize.width / 2;
      y = newSize.height / 2;

      final buttonSize =
          game.sizeConfig.tileSize * TutorialContainerConfig.buttonSize;

      y = newSize.height - (tile * TutorialContainerConfig.buttonPositionY);

      _buttonComponent
        ..size = Vector2(buttonSize, buttonSize)
        ..position = Vector2(
          newSize.width / 2,
          y,
        );

      final spriteAspectRatio = _tutorialBackground.sprite.image.width /
          _tutorialBackground.sprite.image.height;
      final tutorialBackgroundWidth = newSize.height * spriteAspectRatio;

      _tutorialBackground
        ..size = Vector2(
          tutorialBackgroundWidth,
          newSize.height,
        )
        ..position = Vector2(x, y);

      _resultBackgroundComponent.size = Vector2(newSize.width, newSize.height);

      super.onGameResize(size);
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.status == CatcherGameStatusType.tutorial) {
      _resultBackgroundComponent.render(canvas);
      _tutorialBackground.render(canvas);
      _buttonComponent.render(canvas);
    }
  }

  @override
  void update(double dt) {
    if (game.status == CatcherGameStatusType.tutorial) {
      super.update(dt);
    }
  }

  void showTutorial() {
    game.status = CatcherGameStatusType.tutorial;
    scene.onPauseResumeGameCallback();
    _buttonComponent.isVisible = true;
    _tutorialBackground.isVisible = true;
    game.overlays.remove(TimerOverlay.id);
  }

  @override
  bool containsLocalPoint(Vector2 point) =>
      game.status == CatcherGameStatusType.tutorial;

  @override
  void onTapDown(TapDownEvent event) {
    if (_buttonComponent.toRect().contains(event.canvasPosition.toOffset())) {
      _buttonComponent.isVisible = false;
      _tutorialBackground.isVisible = false;
      game.overlays.add(TimerOverlay.id);
      game.status = CatcherGameStatusType.pause;
      scene.onPauseResumeGameCallback();
    }
  }

  void onHideTutorial() {
    _buttonComponent.isVisible = false;
    _tutorialBackground.isVisible = false;
    game.overlays.add(TimerOverlay.id);
    game.status = CatcherGameStatusType.pause;
    scene.onPauseResumeGameCallback();
  }
}
