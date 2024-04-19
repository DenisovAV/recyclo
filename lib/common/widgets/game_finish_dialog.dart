import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/common/widgets/item_container.dart';

const _itemsInnerPadding = 4.0;
const _dialogContentInnerPadding = 12.0;

Future<void> showGameFinishDialog({
  required BuildContext context,
  required List<({ItemType type, int score})> items,
  required VoidCallback onDismiss,
}) async {
  await showDialog<Dialog>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Builder(
        builder: (context) {
          final sortedItems = items.sortedByType();

          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              maxHeight: 600,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  width: 2,
                  color: FlutterGameChallengeColors.textStroke,
                ),
                color: FlutterGameChallengeColors.detailsBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: _dialogContentInnerPadding),
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
                  const SizedBox(height: _dialogContentInnerPadding),
                  Flexible(
                    child: Text(
                      sortedItems.isEmpty
                          ? context.l10n.gameFinishDialogTryAgainDescription
                          : context.l10n.gameFinishDialogDescription,
                      style: const TextStyle(
                        color: FlutterGameChallengeColors.textStroke,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (sortedItems.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final desirableItemScale = constraints.maxWidth /
                              ((ItemContainer.containerSize +
                                      _itemsInnerPadding * 2) *
                                  ItemType.values.length);

                          final itemScale = desirableItemScale > 1.0
                              ? 1.0
                              : desirableItemScale;

                          return SizedBox(
                            height: ItemContainer.containerSize * itemScale,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: sortedItems
                                  .map(
                                    (e) => Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            items.indexOf(e) < items.length - 1
                                                ? _itemsInnerPadding
                                                : 0.0,
                                      ),
                                      child: ItemContainer(
                                        type: e.type,
                                        count: e.score,
                                        scale: itemScale,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
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
          );
        },
      ),
    ),
  );
}
