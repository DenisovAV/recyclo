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
          url: 'https://pub.dev',
        ),
        SizedBox(
          width: 15,
        ),
        _DownloadButton(
          image: Assets.images.downloadAppleStoreButton.image(),
          url: 'https://pub.dev',
        ),
        SizedBox(
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
  final Widget image;
  final String url;

  const _DownloadButton({
    required this.image,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _goToLink(url);
        },
        child: image,
      ),
    );
  }

  void _goToLink(String link) {
    launchUrl(Uri.parse(link));
  }
}

class PlayOnlineButton extends StatelessWidget {
  final VoidCallback onTap;

  const PlayOnlineButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: FlutterGameChallengeColors.textStroke,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        onTap: onTap,
        child: Container(
          height: 40,
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              width: 1,
              color: FlutterGameChallengeColors.teamBackground,
            ),
          ),
          child: Center(
            child: Text(
              l10n.playOnlineButtonTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
