import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
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
