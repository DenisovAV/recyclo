import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';

extension BuildContextExtensions on BuildContext {
  TextStyle textStyle({
    double fontSize = 46,
    double height = 2,
  }) =>
      TextStyle(
        fontSize: fontSize,
        fontFamily: 'Sniglet',
        height: height,
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
    Color color = FlutterGameChallengeColors.textStroke,
  }) =>
      TextStyle(
        fontSize: fontSize,
        fontFamily: 'Sniglet',
        color: color,
      );
}
