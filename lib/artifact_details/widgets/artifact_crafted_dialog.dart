import 'package:flutter/widgets.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/widgets/tv_button.dart';

class GameMessageDialog extends StatelessWidget {
  const GameMessageDialog({
    required this.title,
    required this.body,
    this.onClose,
    super.key,
  });
  final String title;
  final String body;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 720,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
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
            if (ExtendedPlatform.isTv)
              TvButton(
                text: context.l10n.buttonOk,
                autofocus: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            else
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
