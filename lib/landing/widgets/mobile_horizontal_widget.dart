import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';

class MobileHorizontalWidget extends StatelessWidget {
  const MobileHorizontalWidget({
    super.key,
    required this.isStart,
    required this.text,
    required this.image,
    this.title,
  });
  final bool isStart;
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: 4,
            color: FlutterGameChallengeColors.textStroke,
          ),
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
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: BrandText(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ]
              : [
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: BrandText(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                  ),
                  const SizedBox(
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
