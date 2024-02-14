import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/common.dart';

class ArtifactRequirementsStatus extends StatelessWidget {
  const ArtifactRequirementsStatus({
    required this.imagePath,
    required this.count,
    required this.isEnough,
    required this.color,
    super.key,
  });

  final String imagePath;
  final int count;
  final bool isEnough;
  final Color color;

  static const _width = 66.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              Image.asset(
                imagePath,
                width: 32,
                height: 32,
              ),
              Text(
                count.toString(),
                style: const TextStyle(
                  color: FlutterGameChallengeColors.textStroke,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
