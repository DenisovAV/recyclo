import 'package:recyclo/common.dart';
import 'package:recyclo/landing/models/team_member.dart';

class TeamConstants {
  static const mobileCommunityLink = 'https://wearecommunity.io/communities/mobilepeople';
  static List<TeamMember> teams = <TeamMember>[
    TeamMember(
      fullName: 'Sasha Denisov',
      role: 'Team Lead',
      photo: Assets.images.sashaPhoto,
      color: FlutterGameChallengeColors.sashaColor,
      profileUrl: 'https://www.linkedin.com/in/aleks-denisov/',
    ),
    TeamMember(
      fullName: 'Dmytro Aprelenko',
      role: 'Developer',
      photo: Assets.images.dimaPhoto,
      color: FlutterGameChallengeColors.dimaColor,
      profileUrl: 'https://www.linkedin.com/in/dmytroaprelenko/',
    ),
    TeamMember(
      fullName: 'Viktor Krechetov',
      role: 'Developer',
      photo: Assets.images.vityaPhoto,
      color: FlutterGameChallengeColors.vityaColor,
      profileUrl: 'https://www.linkedin.com/in/viktor-krechetov-2b9579169/',
    ),
    TeamMember(
      fullName: 'Uladzimir Paliukhovich',
      role: 'Developer',
      photo: Assets.images.vovaPhoto,
      color: FlutterGameChallengeColors.vovaColor,
      profileUrl: 'https://www.linkedin.com/in/uladzimir-paliukhovich-025a93104/',
    ),
    TeamMember(
      fullName: 'Yehor Pavliukov',
      role: 'Developer',
      photo: Assets.images.yehorPhoto,
      color: FlutterGameChallengeColors.yehorColor,
      profileUrl: 'https://www.linkedin.com/in/yehor-pavlyukov-4a082312a/',
    ),
    TeamMember(
      fullName: 'Nikita Chugayevich',
      role: 'Developer',
      photo: Assets.images.nikitaPhoto,
      color: FlutterGameChallengeColors.nikitaColor,
      profileUrl: 'https://www.linkedin.com/in/nikita-chugayevich-7681a1161/',
    ),
    TeamMember(
      fullName: 'Yurii Hurtovyi',
      role: 'Designer',
      photo: Assets.images.yuraPhoto,
      color: FlutterGameChallengeColors.yuraColor,
      profileUrl: 'https://www.linkedin.com/in/yurii-hurtovyi-243214174/',
    ),
  ];
}
