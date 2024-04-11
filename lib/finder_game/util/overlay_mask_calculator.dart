import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/finder_game/const/finder_constraints.dart';
import 'package:vector_math/vector_math_64.dart';

class OverlayMaskCalculator {
  static Rect getTargetRectSize(Vector2 overlaySize) {
    return Rect.fromLTRB(
      0,
      0,
      overlaySize.x,
      overlaySize.y,
    );
  }

  static double getZoomFactorInPixels(Vector2 overlaySize) {
    return FinderConstraints.kHoleZoomFactor * overlaySize.x;
  }

  static Rect getMaskRect({
    required Rect overlayTargetRect,
    required Size fittedSourceSize,
    required Size maskSize,
    required Vector2 dragPosition,
  }) {
    final rectSize = overlayTargetRect.size;

    return Alignment.center.inscribe(
      fittedSourceSize,
      Offset(
            fittedSourceSize.width / 2 -
                getAxisOffset(
                  fittedMeasurement: fittedSourceSize.width,
                  axisDragPosition: dragPosition.x,
                  rectMeasurement: rectSize.width,
                ),
            fittedSourceSize.height / 2 -
                getAxisOffset(
                  fittedMeasurement: fittedSourceSize.height,
                  axisDragPosition: dragPosition.y,
                  rectMeasurement: rectSize.height,
                ) +
                FinderConstraints.kVerticalHolePositionOffset,
          ) &
          maskSize,
    );
  }

  static double getAxisOffset({
    required double fittedMeasurement,
    required double axisDragPosition,
    required double rectMeasurement,
  }) {
    return fittedMeasurement * axisDragPosition / rectMeasurement;
  }
}
