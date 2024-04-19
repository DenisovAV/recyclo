import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';

class LandingLogo extends StatelessWidget {
  final double fontSize;

  const LandingLogo({super.key, this.fontSize = 36});

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
            fontSize: fontSize,
          ),
        )
      ],
    );
  }
}
