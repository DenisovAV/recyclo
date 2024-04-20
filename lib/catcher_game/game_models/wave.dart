import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:recyclo/catcher_game/game_models.dart';

@immutable
class Wave extends Equatable {
  const Wave({
    required this.dropDiversityList,
    required this.minDroppingInterval,
    required this.maxDroppingInterval,
    required this.minDroppingSpeed,
    required this.maxDroppingSpeed,
    this.itemsInWave,
  });

  final List<Drop> dropDiversityList;
  final double minDroppingInterval;
  final double maxDroppingInterval;
  final double minDroppingSpeed;
  final double maxDroppingSpeed;
  final int? itemsInWave;

  @override
  String toString() => 'Wave{dropDiversityList: $dropDiversityList, '
      'minIteraval: $minDroppingInterval, '
      'maxInteval: $maxDroppingInterval, '
      'minSpeed: $minDroppingSpeed, '
      'maxSpeed: $maxDroppingSpeed, '
      'itemsInWave: $itemsInWave}';

  @override
  List<Object?> get props => [
        dropDiversityList,
        minDroppingInterval,
        maxDroppingInterval,
        minDroppingSpeed,
        maxDroppingSpeed,
        itemsInWave,
      ];
}
