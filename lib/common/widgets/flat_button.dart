import 'package:flutter/widgets.dart';
import 'package:recyclo/common/assets/colors.gen.dart';

class FlatButton extends StatelessWidget {
  const FlatButton({
    required this.onPressed,
    required this.text,
    this.isActive = true,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isActive;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          return;
        }
        onPressed.call();
      },
      child: Opacity(
        opacity: isActive ? 1 : 0.4,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: FlutterGameChallengeColors.textStroke,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: FlutterGameChallengeColors.white,
              fontSize: 26,
              fontFamily: 'Sniglet'
            ),
          ),
        ),
      ),
    );
  }
}
