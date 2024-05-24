import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';

class MobileVerticalWidget extends StatelessWidget {
  const MobileVerticalWidget({
    super.key,
    required this.text,
    required this.image,
    this.title,
  });
  final String text;
  final Widget image;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          const SizedBox(
            height: 30,
          ),
          BrandText(
            title!,
            style: const TextStyle(
              color: FlutterGameChallengeColors.textStroke,
              fontSize: 24,
            ),
          ),
          const SizedBox(
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
          margin: const EdgeInsets.symmetric(horizontal: 30),
          height: 4,
          color: FlutterGameChallengeColors.textStroke,
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: BrandText(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: FlutterGameChallengeColors.textStroke,
            ),
          ),
        ),
      ],
    );
  }
}
