import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';

class LandingLogo extends StatelessWidget {
  const LandingLogo({super.key, this.fontSize = 36});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Assets.images.recycleLogoSvg.svg(width: 65),
        const SizedBox(
          width: 15,
        ),
        Text(
          l10n.appName,
          style: TextStyle(
            color: FlutterGameChallengeColors.white,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
