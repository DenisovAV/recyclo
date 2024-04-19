import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/common/team_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkWidget extends StatelessWidget {
  final Color linkColor;

  const LinkWidget({
    super.key,
    required this.linkColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      child: Semantics(
        label: l10n.aboutAppRecycleLink,
        button: true,
        enabled: true,
        excludeSemantics: true,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          onTap: _launchHref,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 1,
                color: linkColor,
              ),
            ),
            child: Text(
              l10n.aboutAppRecycleLink,
              style: TextStyle(
                fontSize: 14,
                color: linkColor,
              ),
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
