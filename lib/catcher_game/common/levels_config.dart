import 'package:flutter_game_challenge/catcher_game/common/speed_convector.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/fallen/recycle_type.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/model/drop.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/model/level.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/model/wave.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Levels {
  static const int initialLevel = 1;

  static List<Level> levels = [
    Level(
      number: 0,
      waves: [
        Wave(
          delay: 1,
          itemsInWave: 3,
          dropDiversityList: const [
            Drop(type: RecycleType.organic, varietyBounder: 11),
            Drop(type: RecycleType.electric, varietyBounder: 5),
            Drop(type: RecycleType.glass, varietyBounder: 8),
            Drop(type: RecycleType.paper, varietyBounder: 5),
            Drop(type: RecycleType.plastic, varietyBounder: 4),
          ],
          minDroppingSpeed: 12.0.rangeToSpeed(),
          maxDroppingSpeed: 13.0.rangeToSpeed(),
          minDroppingInterval: 1.5,
          maxDroppingInterval: 2,
        ),
        Wave(
          delay: 1,
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
          maxDroppingInterval: 2,
        ),
        Wave(
          delay: 1,
          itemsInWave: 20,
          dropDiversityList: const [
            Drop(type: RecycleType.organic, varietyBounder: 11),
            Drop(type: RecycleType.electric, varietyBounder: 5),
            Drop(type: RecycleType.glass, varietyBounder: 8),
            Drop(type: RecycleType.paper, varietyBounder: 5),
            Drop(type: RecycleType.plastic, varietyBounder: 5),
          ],
          minDroppingSpeed: 14.0.rangeToSpeed(),
          maxDroppingSpeed: 15.0.rangeToSpeed(),
          minDroppingInterval: 1.5,
          maxDroppingInterval: 2,
        ),
        Wave(
          delay: 1,
          itemsInWave: 5,
          dropDiversityList: const [
            Drop(type: RecycleType.organic, varietyBounder: 11),
            Drop(type: RecycleType.electric, varietyBounder: 5),
            Drop(type: RecycleType.glass, varietyBounder: 8),
            Drop(type: RecycleType.paper, varietyBounder: 5),
            Drop(type: RecycleType.plastic, varietyBounder: 4),
          ],
          minDroppingSpeed: 12.0.rangeToSpeed(),
          maxDroppingSpeed: 13.0.rangeToSpeed(),
          minDroppingInterval: 1.5,
          maxDroppingInterval: 2,
        ),
        Wave(
          delay: 1,
          itemsInWave: 10,
          dropDiversityList: const [
            Drop(type: RecycleType.organic, varietyBounder: 11),
            Drop(type: RecycleType.electric, varietyBounder: 5),
            Drop(type: RecycleType.glass, varietyBounder: 8),
            Drop(type: RecycleType.paper, varietyBounder: 5),
            Drop(type: RecycleType.plastic, varietyBounder: 5),
          ],
          minDroppingSpeed: 14.0.rangeToSpeed(),
          maxDroppingSpeed: 15.0.rangeToSpeed(),
          minDroppingInterval: 1.5,
          maxDroppingInterval: 2,
        ),
      ],
    ),
  ];
}
