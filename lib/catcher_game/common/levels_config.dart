import 'dart:math';

import 'package:flutter_game_challenge/catcher_game/game_models/drop.dart';
import 'package:flutter_game_challenge/catcher_game/game_models/level.dart';
import 'package:flutter_game_challenge/catcher_game/game_models/wave.dart';
import 'package:flutter_game_challenge/common.dart';

abstract class Levels {
  static List<Level> levels(GameDifficultyType difficulty) => [
        Level(
          number: 0,
          waves: [
            Wave(
              itemsInWave: 5,
              dropDiversityList: [
                _getInitialDrop(5),
              ],
              minDroppingSpeed: difficulty.minSpeed,
              maxDroppingSpeed: difficulty.maxSpeed,
              minDroppingInterval: difficulty.minInterval,
              maxDroppingInterval: difficulty.maxInterval,
            ),
            Wave(
              itemsInWave: 10,
              dropDiversityList: const [
                Drop(type: ItemType.organic, varietyBounder: 11),
                Drop(type: ItemType.electronic, varietyBounder: 5),
                Drop(type: ItemType.glass, varietyBounder: 8),
                Drop(type: ItemType.paper, varietyBounder: 5),
                Drop(type: ItemType.plastic, varietyBounder: 5),
              ],
              minDroppingSpeed: difficulty.minSpeed,
              maxDroppingSpeed: difficulty.maxSpeed,
              minDroppingInterval: difficulty.minInterval,
              maxDroppingInterval: difficulty.maxInterval,
            ),
            Wave(
              dropDiversityList: const [
                Drop(type: ItemType.organic, varietyBounder: 11),
                Drop(type: ItemType.electronic, varietyBounder: 5),
                Drop(type: ItemType.glass, varietyBounder: 8),
                Drop(type: ItemType.paper, varietyBounder: 5),
                Drop(type: ItemType.plastic, varietyBounder: 5),
              ],
              minDroppingSpeed: difficulty.minSpeed,
              maxDroppingSpeed: difficulty.maxSpeed,
              minDroppingInterval: difficulty.minInterval,
              maxDroppingInterval: difficulty.maxInterval,
            ),
          ],
        ),
      ];

  static Drop _getInitialDrop(int varietyBounder) {
    final index = varietyBounder >= ItemType.values.length - 1
        ? ItemType.values.length - 1
        : varietyBounder;

    final type = ItemType.values[Random().nextInt(index)];
    return Drop(
      type: type,
      varietyBounder: type.assetsVarietyBounder,
    );
  }
}

extension on GameDifficultyType {
  double get minSpeed => switch (this) {
        GameDifficultyType.easy => 0.003,
        GameDifficultyType.medium => 0.004,
        GameDifficultyType.hard => 0.005,
      };

  double get maxSpeed => switch (this) {
        GameDifficultyType.easy => 0.004,
        GameDifficultyType.medium => 0.006,
        GameDifficultyType.hard => 0.006,
      };

  double get minInterval => switch (this) {
        GameDifficultyType.easy => 2.0,
        GameDifficultyType.medium => 1.5,
        GameDifficultyType.hard => 1.5,
      };

  double get maxInterval => switch (this) {
        GameDifficultyType.easy => 3.0,
        GameDifficultyType.medium => 2.0,
        GameDifficultyType.hard => 1.8,
      };
}
