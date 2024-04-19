import 'package:flutter/material.dart';
import 'package:recyclo/artifacts/artifacts_model.dart';
import 'package:recyclo/common.dart';

class ArtifactStatusIcon extends StatelessWidget {
  const ArtifactStatusIcon({
    required this.status,
    super.key,
  });

  final ArtifactStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getColorByStatus(),
        border: Border.all(
          width: 2,
          color: FlutterGameChallengeColors.textStroke,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: _getImageByStatus(),
    );
  }

  Widget _getImageByStatus() {
    switch (status) {
      case ArtifactStatus.notEnoughResources:
        return Assets.images.iconForbidden.image();
      case ArtifactStatus.readyForCraft:
        return Assets.images.iconGeer.image();
      case ArtifactStatus.crafted:
        return Assets.images.iconOk.image();
      case ArtifactStatus.addedToWallet:
        return Assets.images.iconWallet.image();
    }
  }

  Color _getColorByStatus() {
    switch (status) {
      case ArtifactStatus.notEnoughResources:
        return FlutterGameChallengeColors.artifactRed;
      case ArtifactStatus.readyForCraft:
        return FlutterGameChallengeColors.artifactOrange;
      case ArtifactStatus.crafted:
        return FlutterGameChallengeColors.artifactGreen;
      case ArtifactStatus.addedToWallet:
        return FlutterGameChallengeColors.white;
    }
  }
}
