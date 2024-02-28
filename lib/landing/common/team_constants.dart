import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/models/team_member.dart';

class TeamConstants {
  static List<TeamMember> teams = <TeamMember>[
    TeamMember(
      fullName: 'Sasha Denisov',
      role: 'Developer',
      photo: Assets.images.sashaPhoto,
      color: FlutterGameChallengeColors.sashaColor,
    ),
    TeamMember(
      fullName: 'Dmytro Aprelenko',
      role: 'Developer',
      photo: Assets.images.dimaPhoto,
      color: FlutterGameChallengeColors.dimaColor,
    ),
    TeamMember(
      fullName: 'Viktor Krechetov',
      role: 'Developer',
      photo: Assets.images.vityaPhoto,
      color: FlutterGameChallengeColors.vityaColor,
    ),
    TeamMember(
      fullName: 'Uladzimir Paliukhovich',
      role: 'Developer',
      photo: Assets.images.vovaPhoto,
      color: FlutterGameChallengeColors.vovaColor,
    ),
    TeamMember(
      fullName: 'Yehor Pavliukov',
      role: 'Developer',
      photo: Assets.images.yehorPhoto,
      color: FlutterGameChallengeColors.yehorColor,
    ),
    TeamMember(
      fullName: 'Nikita Chugayevich',
      role: 'Developer',
      photo: Assets.images.nikitaPhoto,
      color: FlutterGameChallengeColors.nikitaColor,
    ),
    TeamMember(
      fullName: 'Yurii Hurtovyi',
      role: 'Designer',
      photo: Assets.images.nikitaPhoto,
      color: FlutterGameChallengeColors.yuraColor,
    ),
  ];
}
