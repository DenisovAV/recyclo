import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/widgets/download_button.dart';
import 'package:recyclo/loading/loading.dart';

class DownloadFromStoresWidget extends StatelessWidget {
  const DownloadFromStoresWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      alignment: WrapAlignment.center,
      children: [
        DownloadButton(
          image: Assets.images.downloadGooglePlayButton.image(),
          url: 'https://play.google.com/store/apps/details?id=dev.recyclo.games',
        ),
        DownloadButton(
          image: Assets.images.downloadAppleStoreButton.image(),
          url: 'https://apps.apple.com/de/app/recyclo-game/id6479239285',
        ),
        PlayOnlineButton(
          onTap: () {
            Navigator.of(context).push(LoadingPage.route());
          },
        ),
      ],
    );
  }
}

class PlayOnlineButton extends StatelessWidget {
  const PlayOnlineButton({
    super.key,
    required this.onTap,
  });
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: FlutterGameChallengeColors.textStroke,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Semantics(
        label: l10n.playOnlineButtonTitle,
        button: true,
        enabled: true,
        excludeSemantics: true,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          onTap: onTap,
          child: Container(
            height: 40,
            width: 130,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                color: FlutterGameChallengeColors.teamBackground,
              ),
            ),
            child: Center(
              child: Text(
                l10n.playOnlineButtonTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
