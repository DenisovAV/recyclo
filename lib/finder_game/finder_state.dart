import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/clicker_game/game_models/trash_bin.dart';
import 'package:flutter_game_challenge/clicker_game/game_models/trash_type.dart';
import 'package:flutter_game_challenge/finder_game/components/item.dart';
import 'package:flutter_game_challenge/finder_game/const/finder_constraints.dart';
import 'package:flutter_game_challenge/common.dart';

class FinderState extends Component {
  FinderState({required this.gameWidgetSize})
      : currentTargetTypes = ValueNotifier([]),
        trashItems = ValueNotifier([]),
        _sortedTrash = {},
        _trashBin = TrashBin();

  final Vector2 gameWidgetSize;

  final ValueNotifier<List<TrashType>> currentTargetTypes;
  final ValueNotifier<List<Item>> trashItems;
  final TrashBin _trashBin;
  final Map<TrashType, int> _sortedTrash;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _generateTrashItems();
  }

  void punishPlayer() {
    // TODO: show tutorial overlay on 3-rd miss =- take 5 seconds away
  }

  void collectTrash(Item trash) {
    trashItems.value.remove(trash);
    currentTargetTypes.value = List.from(
      currentTargetTypes.value..removeLast(),
    );
    final currentValue = _sortedTrash[trash.trashData.classification] ?? 0;
    _sortedTrash[trash.trashData.classification] = currentValue + 1;
  }

  List<(ItemType, int)> generateCollectedResources() {
    final result = <(ItemType, int)>[];
    _sortedTrash.forEach((key, value) {
      result.add((key.asItemType, value));
    });

    return result;
  }

  void _generateTrashItems() {
    final cellWidth = Item.baseSize.x;
    final cellHeight = Item.baseSize.y;

    final columns =
        ((gameWidgetSize.x - 2 * FinderConstraints.sidePadding) / cellWidth)
            .floor();
    final rowsVisible =
        ((gameWidgetSize.y - FinderConstraints.topTrashPadding) / cellHeight)
            .floor();

    for (var row = 0;
        row < rowsVisible + FinderConstraints.extraRowsGenerated;
        ++row) {
      for (var col = 0; col < columns; ++col) {
        final xOffset = (row.isEven) ? 20 : 0;

        final position = Vector2(
          col * cellWidth +
              cellWidth / 2 +
              FinderConstraints.sidePadding +
              xOffset,
          row < rowsVisible
              ? gameWidgetSize.y - (row + 1) * cellHeight
              : gameWidgetSize.y + (row - rowsVisible) * cellHeight,
        );

        final trashItem = Item(
          _trashBin.randomTrash,
          position: position,
        );
        trashItems.value.add(trashItem);

        if (row < rowsVisible) {
          currentTargetTypes.value.add(trashItem.trashData.classification);
        }
      }
    }
  }
}
