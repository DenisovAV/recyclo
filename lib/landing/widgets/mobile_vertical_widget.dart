import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/widgets/brand_text.dart';

class MobileVerticalWidget extends StatelessWidget {
  final String text;
  final Widget image;
  final String? title;

  const MobileVerticalWidget({
    super.key,
    required this.text,
    required this.image,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null) ...[
          SizedBox(
            height: 30,
          ),
          BrandText(
            title!,
            style: TextStyle(
              color: FlutterGameChallengeColors.textStroke,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: image,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          height: 4,
          color: FlutterGameChallengeColors.textStroke,
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: BrandText(
            text,
            style: TextStyle(
              fontSize: 20,
              color: FlutterGameChallengeColors.textStroke,
            ),
          ),
        ),
      ],
    );
  }
}
