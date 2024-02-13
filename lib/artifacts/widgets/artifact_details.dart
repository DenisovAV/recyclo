import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifact_status_icon.dart';
import 'package:flutter_game_challenge/artifacts/widgets/game_button.dart';
import 'package:flutter_game_challenge/common.dart';

class ArtifactDetails extends StatelessWidget {
  const ArtifactDetails({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.model,
    super.key,
  });

  final String imagePath;
  final String name;
  final String description;
  final ArtifactModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          width: 2,
          color: FlutterGameChallengeColors.textStroke,
        ),
        color: FlutterGameChallengeColors.detailsBackground,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        child: Image.asset(imagePath),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ArtifactStatusIcon(
                            status: model.status,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: FlutterGameChallengeColors.textStroke,
                            fontSize: 36,
                          ),
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                            color: FlutterGameChallengeColors.textStroke,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GameButton(
              onPressed: () {},
              isActive: model.status == ArtifactStatus.readyForCraft,
              text: context.l10n.buttonCraft,
            ),
          ),
        ],
      ),
    );
  }
}
