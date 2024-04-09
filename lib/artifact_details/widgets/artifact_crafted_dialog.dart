import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/common.dart';

class GameMessageDialog extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onClose;

  const GameMessageDialog({
    required this.title,
    required this.body,
    this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 720,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: FlutterGameChallengeColors.detailsBackground,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            width: 2,
            color: FlutterGameChallengeColors.textStroke,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.generalTextStyle(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: context.generalTextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            FlatButton(
              text: context.l10n.buttonOk,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
