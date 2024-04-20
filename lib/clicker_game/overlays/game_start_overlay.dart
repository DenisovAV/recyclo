import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/common/extensions.dart';

class GameStartOverlay extends StatelessWidget {
  const GameStartOverlay({
    required this.onPressed,
    super.key,
  });

  static const id = 'game_start_overlay';

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            'Start game',
            style: context.textStyle(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
