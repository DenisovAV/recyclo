import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game_challenge/catcher_game/background/background.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/common/solid_background.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/tutorial/tutorial_config.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/main_scene.dart';

class TutorialContainer extends PositionComponent with HasGameRef<CatcherGame> {
  TutorialContainer({
    required this.scene,
  });

  final MainScene scene;

  late final Sprite _tutorialBackground;
  late final SolidBackground _resultBackgroundComponent;
  late final Background _backgroundComponent;
  late final SpriteComponent _buttonComponent;

  @override
  FutureOr<void> onLoad() {
    _resultBackgroundComponent = SolidBackground.withAlpha(TutorialContainerConfig.backgroundAlpha);

    _buttonComponent = SpriteComponent.fromImage(
      game.images.fromCache(TutorialContainerConfig.tutorialButtonPlayAsset),
      anchor: Anchor.center,
    );

    _tutorialBackground = Sprite(game.images.fromCache(TutorialContainerConfig.tutorialAsset));
    _backgroundComponent = Background(sprite: _tutorialBackground);

    this
      ..add(_resultBackgroundComponent)
      ..add(_backgroundComponent)
      ..add(_buttonComponent);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    if (isLoaded) {
      final newSize = size.toSize();

      x = newSize.width / 2;
      y = newSize.height / 2;

      final buttonSize = game.sizeConfig.tileSize * TutorialContainerConfig.buttonSize;

      _buttonComponent
        ..size = Vector2(buttonSize, buttonSize)
        ..position = Vector2(newSize.width / 2,
            newSize.height - (buttonSize * TutorialContainerConfig.buttonPositionY));

      _resultBackgroundComponent.size = Vector2(newSize.width, newSize.height);

      super.onGameResize(size);
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.status == CatcherGameStatus.tutorial) {
      super.render(canvas);
    }
  }

  @override
  void update(double dt) {
    if (game.status == CatcherGameStatus.tutorial) {
      super.update(dt);
    }
    if (scene.isDestroy) {
      removeFromParent();
    }
  }

  void showTutorial() {
    game.status = CatcherGameStatus.tutorial;
  }

  void onTapDown(TapDownEvent event) {
    if (_buttonComponent.toRect().contains(event.localPosition.toOffset())) {
      game.status = CatcherGameStatus.playing;
    }
  }
}
