import 'package:flutter/cupertino.dart';
import 'package:recyclo/common.dart';

class TeamMember {

  TeamMember({
    required this.fullName,
    required this.role,
    required this.photo,
    required this.color,
    required this.profileUrl,
  });
  final String fullName;
  final String role;
  final AssetGenImage photo;
  final Color color;
  final String profileUrl;
}
