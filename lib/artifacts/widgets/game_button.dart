import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common/assets/colors.gen.dart';

class GameButton extends StatelessWidget {
  const GameButton({
    required this.onPressed,
    required this.text,
    this.isActive = true,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isActive;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isActive ? 1 : 0.4,
      child: Material(
        color: FlutterGameChallengeColors.textStroke,
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: isActive ? onPressed : null,
          child: Container(
            height: 52,
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: FlutterGameChallengeColors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
