
import 'package:flutter/material.dart';

class BrandText extends StatelessWidget {

  const BrandText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}
