import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/common/team_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkWidget extends StatelessWidget {
  const LinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: _launchHref,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 1,
              color: FlutterGameChallengeColors.aboutAppBackground,
            ),
          ),
          child: Text(
            l10n.aboutAppRecycleLink,
            style: TextStyle(
              fontSize: 14,
              color: FlutterGameChallengeColors.aboutAppBackground,
            ),
          ),
        ),
      ),
    );
  }

  void _launchHref() {
    final url = Uri.parse(TeamConstants.mobileCommunityLink);
    launchUrl(url);
  }
}
