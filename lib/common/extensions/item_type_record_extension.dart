import 'package:flutter_game_challenge/common/entities/item_type.dart';

extension ItemTypeListExtension on List<({ItemType type, int score})> {
  List<({ItemType type, int score})> sortedByType() {
    return this
      ..sort(
        (a, b) => a.type.index.compareTo(ItemType.values[b.type.index].index),
      );
  }
}
