import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/common/team_constants.dart';
import 'package:recyclo/landing/models/team_member.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';
import 'package:recyclo/landing/widgets/landing_item.dart';

class TeamItem extends StatelessWidget {
  const TeamItem({super.key});

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
                  children: TeamConstants.teams
                      .map<Widget>(_TeamMemberWidget.new)
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TeamMemberWidget extends StatelessWidget {
  const _TeamMemberWidget(this.member);
  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Row(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(52),
              ),
            ),
            child: Stack(
              children: [
                member.photo.image(),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      border: Border.all(
                        width: 4,
                        color: member.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandText(
                member.fullName,
                style: const TextStyle(
                  fontSize: 20,
                  color: FlutterGameChallengeColors.textStroke,
                ),
              ),
              BrandText(
                member.role,
                style: TextStyle(
                  fontSize: 16,
                  color: FlutterGameChallengeColors.textStroke.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
