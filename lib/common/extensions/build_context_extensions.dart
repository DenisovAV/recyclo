import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';

extension BuildContextExtensions on BuildContext {
  TextStyle textStyle({
    double fontSize = 46,
  }) =>
      TextStyle(
        fontSize: fontSize,
        fontFamily: 'Sniglet',
        height: 2,
        color: FlutterGameChallengeColors.white,
        shadows: const [
          Shadow(
            // bottomLeft
            offset: Offset(-1.5, -1.5),
            color: FlutterGameChallengeColors.textStroke,
          ),
          Shadow(
            // bottomRight
            offset: Offset(1.5, -1.5),
            color: FlutterGameChallengeColors.textStroke,
          ),
          Shadow(
            // topRight
            offset: Offset(1.5, 1.5),
            color: FlutterGameChallengeColors.textStroke,
          ),
          Shadow(
            // topLeft
            offset: Offset(-1.5, 1.5),
            color: FlutterGameChallengeColors.textStroke,
          ),
        ],
      );

  TextStyle generalTextStyle({
    double fontSize = 46,
  }) =>
      TextStyle(
        fontSize: fontSize,
        fontFamily: 'Sniglet',
        color: FlutterGameChallengeColors.textStroke,
      );
}
