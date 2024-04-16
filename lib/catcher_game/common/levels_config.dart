import 'dart:math';

import 'package:flutter_game_challenge/catcher_game/common/speed_convector.dart';
import 'package:flutter_game_challenge/catcher_game/components.dart';
import 'package:flutter_game_challenge/common/entities/item_type.dart';

abstract class Levels {
  static const int initialLevel = 1;

  // TODO(viktor): At this stage, we could still reuse this class to configure the 1 minute game.
  static List<Level> levels() {
    return [
      Level(
        number: 0,
        waves: [
          Wave(
            delay: 0,
            itemsInWave: 5,
            dropDiversityList: [
              _getInitialDrop(5),
            ],
            minDroppingSpeed: 9.0.rangeToSpeed(),
            maxDroppingSpeed: 11.0.rangeToSpeed(),
            minDroppingInterval: 1.2,
            maxDroppingInterval: 1.8,
          ),
          Wave(
            delay: 0.5,
            itemsInWave: 10,
            dropDiversityList: const [
              Drop(type: ItemType.organic, varietyBounder: 11),
              Drop(type: ItemType.electronic, varietyBounder: 5),
              Drop(type: ItemType.glass, varietyBounder: 8),
              Drop(type: ItemType.paper, varietyBounder: 5),
              Drop(type: ItemType.plastic, varietyBounder: 5),
            ],
            minDroppingSpeed: 13.0.rangeToSpeed(),
            maxDroppingSpeed: 14.0.rangeToSpeed(),
            minDroppingInterval: 1.5,
            maxDroppingInterval: 1.8,
          ),
          Wave(
            delay: 1,
            itemsInWave: 100,
            dropDiversityList: const [
              Drop(type: ItemType.organic, varietyBounder: 11),
              Drop(type: ItemType.electronic, varietyBounder: 5),
              Drop(type: ItemType.glass, varietyBounder: 8),
              Drop(type: ItemType.paper, varietyBounder: 5),
              Drop(type: ItemType.plastic, varietyBounder: 5),
            ],
            minDroppingSpeed: 15.0.rangeToSpeed(),
            maxDroppingSpeed: 16.0.rangeToSpeed(),
            minDroppingInterval: 1.5,
            maxDroppingInterval: 1.8,
          ),
          Wave(
            delay: 1,
            itemsInWave: 2000,
            dropDiversityList: const [
              Drop(type: ItemType.organic, varietyBounder: 11),
              Drop(type: ItemType.electronic, varietyBounder: 5),
              Drop(type: ItemType.glass, varietyBounder: 8),
              Drop(type: ItemType.paper, varietyBounder: 5),
              Drop(type: ItemType.plastic, varietyBounder: 5),
            ],
            minDroppingSpeed: 15.0.rangeToSpeed(),
            maxDroppingSpeed: 16.0.rangeToSpeed(),
            minDroppingInterval: 1.5,
            maxDroppingInterval: 1.8,
          ),
          Wave(
            delay: 1,
            itemsInWave: 5000,
            dropDiversityList: const [
              Drop(type: ItemType.organic, varietyBounder: 11),
              Drop(type: ItemType.electronic, varietyBounder: 5),
              Drop(type: ItemType.glass, varietyBounder: 8),
              Drop(type: ItemType.paper, varietyBounder: 5),
              Drop(type: ItemType.plastic, varietyBounder: 5),
            ],
            minDroppingSpeed: 15.0.rangeToSpeed(),
            maxDroppingSpeed: 16.0.rangeToSpeed(),
            minDroppingInterval: 1.5,
            maxDroppingInterval: 1.8,
          ),
        ],
      ),
    ];
  }

  static Drop _getInitialDrop(int varietyBounder) {
    final index = varietyBounder >= ItemType.values.length - 1
        ? ItemType.values.length - 1
        : varietyBounder;

    final type = ItemType.values[Random().nextInt(index)];
    return Drop(
      type: type,
      varietyBounder: type.varietyBounder,
    );
  }
}

extension on ItemType {
  int get varietyBounder {
    switch (this) {
      case ItemType.organic:
        return 11;
      case ItemType.electronic:
        return 5;
      case ItemType.glass:
        return 8;
      case ItemType.paper:
        return 5;
      case ItemType.plastic:
        return 5;
    }
  }
}
