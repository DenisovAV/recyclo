import 'package:flutter/material.dart';
import 'package:recyclo/common/assets/assets.gen.dart';

class Clouds extends StatelessWidget {
  const Clouds({
    required this.highlightAnimation,
    required this.alignment,
    super.key,
  });

  final Animation<double> highlightAnimation;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: highlightAnimation,
      alignment: alignment,
      child: Assets.images.clouds.image(
        width: double.infinity,
        fit: BoxFit.fitWidth,
        alignment: alignment,
      ),
    );
  }
}
