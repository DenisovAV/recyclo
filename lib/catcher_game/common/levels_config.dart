import 'dart:math';

import 'package:flutter_game_challenge/catcher_game/common/speed_convector.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components.dart';

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
              Drop(type: RecycleType.organic, varietyBounder: 11),
              Drop(type: RecycleType.electric, varietyBounder: 5),
              Drop(type: RecycleType.glass, varietyBounder: 8),
              Drop(type: RecycleType.paper, varietyBounder: 5),
              Drop(type: RecycleType.plastic, varietyBounder: 5),
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
              Drop(type: RecycleType.organic, varietyBounder: 11),
              Drop(type: RecycleType.electric, varietyBounder: 5),
              Drop(type: RecycleType.glass, varietyBounder: 8),
              Drop(type: RecycleType.paper, varietyBounder: 5),
              Drop(type: RecycleType.plastic, varietyBounder: 5),
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
    final index = varietyBounder >= RecycleType.values.length - 1
        ? RecycleType.values.length - 1
        : varietyBounder;

    final type = RecycleType.values[Random().nextInt(index)];
    return Drop(
      type: type,
      varietyBounder: type.varietyBounder,
    );
  }
}

extension on RecycleType {
  int get varietyBounder {
    switch (this) {
      case RecycleType.organic:
        return 11;
      case RecycleType.electric:
        return 5;
      case RecycleType.glass:
        return 8;
      case RecycleType.paper:
        return 5;
      case RecycleType.plastic:
        return 5;
    }
  }
}
