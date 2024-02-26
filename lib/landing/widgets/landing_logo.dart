import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';

class LandingLogo extends StatelessWidget {
  const LandingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Assets.images.recycleLogoSvg.svg(width: 65),
        SizedBox(
          width: 15,
        ),
        Text(
          l10n.appName,
          style: TextStyle(
            color: FlutterGameChallengeColors.white,
            fontSize: 36,
          ),
        )
      ],
    );
  }
}
