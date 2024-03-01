import 'dart:ui';

import 'package:flutter/material.dart';

class BrandText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const BrandText(this.text, {
    super.key,
    this.style, this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}
