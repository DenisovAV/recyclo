import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/common/widgets/item_container.dart';

Future<void> showGameFinishDialog({
  required BuildContext context,
  required List<(ItemType type, int score)> items,
  required VoidCallback onDismiss,
}) async {
  await showDialog<Dialog>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            width: 2,
            color: FlutterGameChallengeColors.textStroke,
          ),
          color: FlutterGameChallengeColors.detailsBackground,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Flexible(
                child: Text(
                  context.l10n.gameFinishDialogTitle,
                  style: const TextStyle(
                    color: FlutterGameChallengeColors.textStroke,
                    fontSize: 36,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Text(
                  items.isEmpty
                      ? context.l10n.gameFinishDialogTryAgainDescription
                      : context.l10n.gameFinishDialogDescription,
                  style: const TextStyle(
                    color: FlutterGameChallengeColors.textStroke,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SizedBox(
                    height: ItemContainer.containerSize,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = ItemContainer(
                          type: items[index].$1,
                          count: items[index].$2,
                        );

                        return index > items.length - 1
                            ? item
                            : Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: item,
                              );
                      },
                    ),
                  ),
                ),
              const SizedBox(
                height: 24,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDismiss();
                },
                text: items.isEmpty
                    ? context.l10n.gameFinishDialogTryAgainButtonTitle
                    : context.l10n.gameFinishDialogButtonTitle,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
