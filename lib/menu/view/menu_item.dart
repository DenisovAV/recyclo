import 'package:flutter/widgets.dart';
import 'package:recyclo/common/assets/colors.gen.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.text,
    required this.onTap,
    this.autofocus = false,
    this.assetId,
    super.key,
  });

  final String text;
  final VoidCallback onTap;
  final String? assetId;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 46,
      fontFamily: 'Sniglet',
      height: 2,
      color: FlutterGameChallengeColors.white,
      shadows: [
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

    return Semantics(
      label: text,
      button: true,
      enabled: true,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (assetId != null)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.asset(
                  assetId!,
                  width: 60,
                  height: 60,
                ),
              ),
            Text(
              text,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
