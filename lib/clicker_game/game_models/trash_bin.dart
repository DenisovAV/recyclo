import 'dart:math';

import 'package:recyclo/clicker_game/game_models/trash_item.dart';
import 'package:recyclo/clicker_game/game_models/trash_type.dart';

class TrashBin {
  TrashBin()
      : trash = _loadBin(),
        _random = Random();

  final List<TrashItemData> trash;
  final Random _random;

  TrashItemData get randomTrash {
    return trash[_random.nextInt(trash.length)];
  }

  static List<TrashItemData> _loadBin() {
    final trash = <TrashItemData>[];
    for (final trashType in TrashType.values) {
      trash.addAll(
        trashType.assets.map(
          (e) => TrashItemData(
            name: e.keyName,
            classification: trashType,
            assetPath: e.path,
          ),
        ),
      );
    }
    return trash;
  }
}
