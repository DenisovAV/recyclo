import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recyclo/common/assets/colors.gen.dart';
import 'package:recyclo/common/extensions.dart';
import 'package:recyclo/widgets/focusable.dart';

class TvButton extends StatelessWidget {
  const TvButton({
    required this.text,
    required this.onPressed,
    this.autofocus = false,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Focusable(
      autofocus: autofocus,
      builder: (context, isFocused) {
        return GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 40,
            width: 280,
            decoration: BoxDecoration(
              color: FlutterGameChallengeColors.textStroke,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 2.0,
                color: FlutterGameChallengeColors.artifactGreen.withOpacity(
                  isFocused ? 1 : 0,
                ),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: context.textStyle(fontSize: 20),
              ),
            ),
          ),
        );
      },
    );
  }
}
