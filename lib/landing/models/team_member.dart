import 'package:flutter/cupertino.dart';
import 'package:flutter_game_challenge/common.dart';

class TeamMember {
  final String fullName;
  final String role;
  final AssetGenImage photo;
  final Color color;

  TeamMember({
    required this.fullName,
    required this.role,
    required this.photo,
    required this.color,
  });
}
