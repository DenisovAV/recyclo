import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/common/team_constants.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';
import 'package:recyclo/landing/widgets/landing_item.dart';
import 'package:recyclo/landing/widgets/team_item.dart';

class TeamWidget extends StatelessWidget {
  const TeamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LandingItem(
      color: FlutterGameChallengeColors.aboutAppBackground,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallDevice = constraints.maxWidth < 800;

          return Padding(
            padding: EdgeInsets.all(isSmallDevice ? 15 : 50.0),
            child: Column(
              children: [
                Center(
                  child: BrandText(
                    l10n.teamTitle,
                    style: const TextStyle(
                      fontSize: 48,
                      color: FlutterGameChallengeColors.textStroke,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  children: TeamConstants.teams.map<Widget>(TeamMemberWidget.new).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
