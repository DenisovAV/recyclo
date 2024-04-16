import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';

class TutorialOverlay extends StatelessWidget {
  const TutorialOverlay({
    super.key,
    required this.onBackButtonPressed,
    required this.onGameStart,
  });

  final VoidCallback onBackButtonPressed;
  final VoidCallback onGameStart;

  static const id = 'game_tutorial_overlay';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color(0xFFE0EBF1),
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Assets.images.howToPlayWithoutSpaces.image(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: onGameStart,
                      child: Assets.images.catcher.tutorial.play.image(
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: RoundButton(
                        icon: Icons.keyboard_arrow_left,
                        onPressed: onBackButtonPressed,
                        semanticsLabel: context.l10n.backButtonLabel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
