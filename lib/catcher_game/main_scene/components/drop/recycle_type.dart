import 'package:flutter_game_challenge/common/entities/item_type.dart';

enum RecycleType {
  organic,
  glass,
  plastic,
  electric,
  paper,
}

extension RecycleTypeExtension on RecycleType {
  ItemType toItemType() => switch (this) {
        RecycleType.organic => ItemType.organic,
        RecycleType.glass => ItemType.glass,
        RecycleType.plastic => ItemType.plastic,
        RecycleType.electric => ItemType.electronic,
        RecycleType.paper => ItemType.paper,
      };
}
