import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:recyclo/common.dart';

class Box extends SpriteComponent {
  Box({
    required super.sprite,
    required this.type,
    required this.order,
  }) {
    super.anchor = Anchor.center;
    paint = Paint()..filterQuality = FilterQuality.high;
  }

  int order;
  ItemType type;
  bool isChosen = false;
  EffectController? _effectController;

  @override
  //ignore: must_call_super, intended function override
  void render(Canvas canvas) {
    sprite?.render(
      canvas,
      size: size * scale.y,
      position: position,
      overridePaint: paint,
      anchor: anchor,
    );
    canvas
      ..save()
      ..clipRect(
        Rect.fromCenter(
          center: Offset(width / 2, height),
          width: width,
          height: height / 0.63,
        ),
        clipOp: ClipOp.difference,
      )
      ..restore();
  }

  void animateCatch({
    required bool isSuccessful,
  }) {
    _effectController ??= EffectController(
      duration: 0.2,
      alternate: true,
    );

    final boxColor = isSuccessful
        ? FlutterGameChallengeColors.boxSuccessfulCatchTint
        : FlutterGameChallengeColors.boxUnsuccessfulCatchTint;

    if (_effectController!.completed) {
      _effectController = null;
      _effectController = EffectController(
        duration: 0.2,
        alternate: true,
      );
      add(
        ColorEffect(
          boxColor,
          _effectController!,
          opacityTo: 0.4,
        ),
      );
    } else if (_effectController?.progress == 0 &&
        _effectController?.duration != null) {
      add(
        ColorEffect(
          boxColor,
          _effectController!,
          opacityTo: 0.4,
        ),
      );
    }
  }
}
