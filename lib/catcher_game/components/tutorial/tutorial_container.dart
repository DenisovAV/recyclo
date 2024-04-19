import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:recyclo/catcher_game/common/visible_component.dart';
import 'package:recyclo/catcher_game/components/background/background.dart';
import 'package:recyclo/catcher_game/components/common/common.dart';
import 'package:recyclo/catcher_game/components/tutorial/tutorial.dart';
import 'package:recyclo/catcher_game/game.dart';
import 'package:recyclo/catcher_game/main_scene.dart';
import 'package:recyclo/common.dart';

class TutorialContainer extends PositionComponent
    with HasGameRef<CatcherGame>, TapCallbacks {
  TutorialContainer({
    required this.scene,
  });

  final MainScene scene;

  late final Sprite _tutorialBackground;
  late final SolidBackground _resultBackgroundComponent;
  late final Background _backgroundComponent;
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

    _tutorialBackground = Sprite(
      game.images.fromCache(
        Assets.images.catcher.tutorial.tutorial.path,
      ),
    );
    _backgroundComponent = Background(sprite: _tutorialBackground);

    await addAll([
      _resultBackgroundComponent,
      _backgroundComponent,
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

      _resultBackgroundComponent.size = Vector2(newSize.width, newSize.height);

      super.onGameResize(size);
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.status == CatcherGameStatusType.tutorial) {
      _resultBackgroundComponent.render(canvas);
      _backgroundComponent.render(canvas);
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
    game.overlays.remove(TimerOverlay.id);
  }

  @override
  bool containsLocalPoint(Vector2 point) =>
      game.status == CatcherGameStatusType.tutorial;

  @override
  void onTapDown(TapDownEvent event) {
    if (_buttonComponent.toRect().contains(event.canvasPosition.toOffset())) {
      _buttonComponent.isVisible = false;
      game.overlays.add(TimerOverlay.id);
      game.status = CatcherGameStatusType.pause;
      scene.onPauseResumeGameCallback();
    }
  }
}
