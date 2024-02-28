import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
