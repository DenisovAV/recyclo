import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/clicker_game/game_models/trash_bin.dart';
import 'package:flutter_game_challenge/clicker_game/game_models/trash_type.dart';
import 'package:flutter_game_challenge/finder_game/components/item.dart';
import 'package:flutter_game_challenge/finder_game/const/finder_constraints.dart';
import 'package:flutter_game_challenge/common.dart';

class FinderState extends Component with HasGameRef {
  FinderState({
    required this.gameWidgetSize,
    required this.topPadding,
  })  : currentTargetTypes = ValueNotifier([]),
        trashItems = ValueNotifier([]),
        _sortedTrash = {},
        _trashBin = TrashBin();

  final Vector2 gameWidgetSize;
  final double topPadding;

  final ValueNotifier<List<TrashType>> currentTargetTypes;
  final ValueNotifier<List<Item>> trashItems;
  final TrashBin _trashBin;
  final Map<TrashType, int> _sortedTrash;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _generateTrashItems();
  }

  void collectTrash(Item trash) {
    trashItems.value.remove(trash);
    currentTargetTypes.value = List.from(
      currentTargetTypes.value..removeLast(),
    );
    final currentValue = _sortedTrash[trash.trashData.classification] ?? 0;
    _sortedTrash[trash.trashData.classification] = currentValue + 1;
  }

  List<({ItemType type, int score})> generateCollectedResources() {
    final result = <({ItemType type, int score})>[];
    _sortedTrash.forEach((key, value) {
      result.add((score: value, type: key.asItemType));
    });

    return result;
  }

  void _generateTrashItems() {
    final itemSize = FinderConstraints.getTrashItemSize(game.size.x);
    final cellWidth = itemSize.x;
    final cellHeight = itemSize.y;

    final topTrashPadding = topPadding +
        gameWidgetSize.y *
            FinderConstraints.trashAdditionalTopPaddingPercentage;

    final columns =
        ((gameWidgetSize.x - 2 * FinderConstraints.sidePadding) / cellWidth)
            .floor();
    final rowsVisible =
        ((gameWidgetSize.y - topTrashPadding) / cellHeight).floor();

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
