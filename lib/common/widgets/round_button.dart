import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
    super.key,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      enabled: true,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              width: 2,
              color: FlutterGameChallengeColors.textStroke,
            ),
          ),
          child: Icon(
            icon,
            size: 36,
            color: FlutterGameChallengeColors.textStroke,
          ),
        ),
      ),
    );
  }
}
