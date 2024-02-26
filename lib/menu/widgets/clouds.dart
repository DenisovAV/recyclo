import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';

class Clouds extends StatelessWidget {
  const Clouds({
    required this.highlightAnimation,
    super.key,
  });

  final Animation<double> highlightAnimation;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.4,
      child: ScaleTransition(
        scale: highlightAnimation,
        child: Assets.images.clouds.image(),
      ),
    );
  }
}