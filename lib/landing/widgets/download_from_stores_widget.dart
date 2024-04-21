import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/loading/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadFromStoresWidget extends StatelessWidget {
  const DownloadFromStoresWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _DownloadButton(
          image: Assets.images.downloadGooglePlayButton.image(),
          url: 'https://play.google.com/store/apps/details?id=dev.recyclo.games',
        ),
        const SizedBox(
          width: 15,
        ),
        _DownloadButton(
          image: Assets.images.downloadAppleStoreButton.image(),
          url: 'https://apps.apple.com/de/app/recyclo-game/id6479239285',
        ),
        const SizedBox(
          width: 15,
        ),
        PlayOnlineButton(
          onTap: () {
            Navigator.of(context).push(LoadingPage.route());
          },
        )
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {

  const _DownloadButton({
    required this.image,
    required this.url,
  });
  final Widget image;
  final String url;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Semantics(
        link: true,
        label: url,
        enabled: true,
        excludeSemantics: true,
        child: GestureDetector(
          onTap: () {
            _goToLink(url);
          },
          child: image,
        ),
      ),
    );
  }

  void _goToLink(String link) {
    launchUrl(Uri.parse(link));
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
