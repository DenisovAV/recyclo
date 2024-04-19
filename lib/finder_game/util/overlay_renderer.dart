import 'package:flame/extensions.dart';
import 'package:flutter/rendering.dart';
import 'package:recyclo/finder_game/const/finder_constraints.dart';
import 'package:recyclo/finder_game/util/overlay_mask_calculator.dart';
import 'package:recyclo/finder_game/util/overlay_render_mode.dart';

class OverlayRenderer {
  OverlayRenderer({
    required this.image,
    required this.maskImage,
    required this.decorationImage,
    required this.gameSize,
  }) {
    resize(gameSize);
  }

  final Vector2 gameSize;
  final Image image;
  final Image maskImage;
  final Image decorationImage;

  Size get maskSize => maskImage.size.toSize();
  Size get imageSize => image.size.toSize();

  Rect overlayTargetRect = Rect.fromLTWH(0, 0, 0, 0);
  Rect fogSourceRect = Rect.fromLTWH(0, 0, 0, 0);

  late Size maskScaledSize;
  late FittedSizes maskFittedSizes;
  late FittedSizes fogFittedSizes;

  void resize(Vector2 size) {
    overlayTargetRect = OverlayMaskCalculator.getTargetRectSize(size);

    final maskSize = maskImage.size;
    _setMaskSizes(
      maskWidth: maskSize.x,
      maskHeight: maskSize.y,
      gameWidth: size.x,
    );

    _setFittedSizes();
    _setSourceRectangles();
  }

  void _setMaskSizes({
    required double maskWidth,
    required double maskHeight,
    required double gameWidth,
  }) {
    maskScaledSize = Size(
      maskWidth * FinderConstraints.holeZoomFactor,
      maskHeight * FinderConstraints.holeZoomFactor,
    );
  }

  void _setSourceRectangles() {
    fogSourceRect = Alignment.topCenter
        .inscribe(fogFittedSizes.source, Offset.zero & imageSize);
  }

  void _setFittedSizes() {
    final rectSize = overlayTargetRect.size;
    fogFittedSizes = applyBoxFit(BoxFit.fill, imageSize, rectSize);
    maskFittedSizes = applyBoxFit(BoxFit.cover, maskScaledSize, rectSize);
  }

  void render({
    required OverlayRenderMode mode,
    required Canvas canvas,
    required Paint paint,
    required Vector2 dragPosition,
  }) {
    if (mode == OverlayRenderMode.hole) {
      _drawFogWithHole(canvas, paint, dragPosition);
    } else {
      _drawFog(canvas, paint);
    }
  }

  void _drawFogWithHole(
    Canvas canvas,
    Paint paint,
    Vector2 dragPosition,
  ) {
    final maskSourceRect = OverlayMaskCalculator.getMaskRect(
      overlayTargetRect: overlayTargetRect,
      fittedSourceSize: maskFittedSizes.source,
      maskSize: maskSize,
      dragPosition: dragPosition,
    );

    canvas
      ..saveLayer(overlayTargetRect, paint)
      ..drawImageRect(
        maskImage,
        maskSourceRect,
        overlayTargetRect,
        paint..blendMode = BlendMode.src,
      );

    _drawFog(
      canvas,
      paint..blendMode = BlendMode.srcIn,
    );

    canvas
      ..drawImageRect(
        decorationImage,
        maskSourceRect,
        overlayTargetRect,
        paint..blendMode = BlendMode.srcOver,
      );
  }

  void _drawFog(Canvas canvas, Paint paint) {
    canvas
      ..drawImageRect(
        image,
        fogSourceRect,
        overlayTargetRect,
        paint,
      )
      ..restore();
  }
}
