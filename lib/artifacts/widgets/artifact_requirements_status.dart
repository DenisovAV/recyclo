import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/common.dart';

class ArtifactRequirementsStatus extends StatelessWidget {
  const ArtifactRequirementsStatus({
    required this.type,
    required this.count,
    required this.isEnough,
    required this.color,
    super.key,
  });

  final ItemType type;
  final int count;
  final bool isEnough;
  final Color color;

  static const _width = 56.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.toCraftResourceType(
         count,
        isEnough.toString(),
        type.name,
      ),
      excludeSemantics: true,
      child: Stack(
        children: [
          Container(
            width: _width,
            height: _width,
            decoration: BoxDecoration(
              color: isEnough
                  ? FlutterGameChallengeColors.artifactGreen
                  : FlutterGameChallengeColors.artifactRed,
              border: Border.all(
                color: FlutterGameChallengeColors.textStroke,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          Container(
            width: _width,
            height: _width,
            margin: const EdgeInsets.only(top: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: FlutterGameChallengeColors.textStroke,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Image.asset(
                    type.iconPath,
                  ),
                ),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    color: FlutterGameChallengeColors.textStroke,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
