import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game_challenge/catcher_game/components/buttons/button_config.dart';
import 'package:flutter_game_challenge/catcher_game/components/buttons/button_container.dart';

class ButtonAnimated extends SpriteAnimationComponent {
  ButtonAnimated({
    required this.buttonType,
    required this.onFinishAnimation,
    required super.animation,
    super.anchor = Anchor.center,
    super.playing = false,
    this.isVisible = true,
  });

  final ButtonType buttonType;
  final VoidCallback onFinishAnimation;
  late Rect tappingArea;
  bool isVisible = true;

  @override
  //ignore: must_call_super, intended function override
  void render(Canvas canvas) {
    if (isVisible) {
      animationTicker?.getSprite().render(
            canvas,
            position: position,
            size: size,
            overridePaint: paint,
            anchor: anchor,
          );
    }
  }

  @override
  //ignore: must_call_super, intended function override
  void update(double dt) {
    if (playing) {
      animationTicker?.update(dt);
    }
    if (animationTicker?.done() ?? false) {
      playing = false;
      animationTicker?.reset();
      onFinishAnimation();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    tappingArea = Rect.fromCenter(
      center: Offset(position.x, position.y + (height / 3)),
      width: width * ButtonsContainerConfig.buttonTapAreaWidth,
      height: height * ButtonsContainerConfig.buttonTapAreaHeight,
    );
  }
}
