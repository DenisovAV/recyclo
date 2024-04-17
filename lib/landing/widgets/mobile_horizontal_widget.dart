import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/widgets/brand_text.dart';

class MobileHorizontalWidget extends StatelessWidget {
  final bool isStart;
  final String text;
  final Widget image;
  final String? title;

  const MobileHorizontalWidget({
    super.key,
    required this.isStart,
    required this.text,
    required this.image,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 4,
            color: FlutterGameChallengeColors.textStroke,
          ),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isStart
              ? [
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerRight,
                      widthFactor: 0.7,
                      child: image,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: BrandText(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                ]
              : [
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: BrandText(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.7,
                      child: image,
                    ),
                  ),
                ],
        ),
      ],
    );
  }
}
