import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/models/team_member.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMemberWidget extends StatefulWidget {
  const TeamMemberWidget(this.member, {super.key});

  final TeamMember member;

  @override
  State<TeamMemberWidget> createState() => _TeamMemberWidgetState();
}

class _TeamMemberWidgetState extends State<TeamMemberWidget> {
  late bool _isHovered;

  @override
  void initState() {
    _isHovered = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isHovered ? 0.6 : 1,
      duration: const Duration(milliseconds: 100),
      child: MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _openMemberProfile,
          child: SizedBox(
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
                      widget.member.photo.image(),
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
                              color: widget.member.color,
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
                    Text(
                      widget.member.fullName,
                      style: TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                        decoration: _isHovered ? TextDecoration.none : TextDecoration.underline,
                      ),
                    ),
                    Text(
                      widget.member.role,
                      style: TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke.withOpacity(0.5),
                        decoration: _isHovered ? TextDecoration.none : TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMemberProfile() {
    launchUrl(Uri.parse(widget.member.profileUrl));
  }

  void _onEnter(_) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(_) {
    setState(() {
      _isHovered = false;
    });
  }
}
