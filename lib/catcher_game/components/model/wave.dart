import 'package:flutter/foundation.dart';
import 'package:flutter_game_challenge/catcher_game/common/config.dart';
import 'package:flutter_game_challenge/catcher_game/components.dart';
import 'package:flutter_game_challenge/common/entities/item_type.dart';

@immutable
class Wave {
  const Wave({
    int? itemsInWave,
    List<Drop>? dropDiversityList,
    double? minDroppingInterval,
    double? maxDroppingInterval,
    double? minDroppingSpeed,
    double? maxDroppingSpeed,
    double? delay,
  })  : itemsInWave = itemsInWave ?? DebugBalancingTableConfig.defaultItems,
        dropDiversityList =
            dropDiversityList ?? const [Drop(type: ItemType.organic)],
        minDroppingInterval =
            minDroppingInterval ?? DebugBalancingTableConfig.minInterval,
        maxDroppingInterval =
            maxDroppingInterval ?? DebugBalancingTableConfig.maxInterval,
        minDroppingSpeed =
            minDroppingSpeed ?? DebugBalancingTableConfig.minSpeed,
        maxDroppingSpeed =
            maxDroppingSpeed ?? DebugBalancingTableConfig.maxSpeed,
        delay = delay ?? DebugBalancingTableConfig.defaultDelay;

  final int itemsInWave;
  final List<Drop> dropDiversityList;
  final double minDroppingInterval;
  final double maxDroppingInterval;
  final double minDroppingSpeed;
  final double maxDroppingSpeed;
  final double delay;

  Wave copyWith({
    int? itemsInWave,
    List<Drop>? dropDiversityList,
    double? minDroppingInterval,
    double? maxDroppingInterval,
    double? minDroppingSpeed,
    double? maxDroppingSpeed,
    double? delay,
  }) =>
      Wave(
        itemsInWave: itemsInWave ?? this.itemsInWave,
        dropDiversityList: dropDiversityList ?? this.dropDiversityList,
        minDroppingInterval: minDroppingInterval ?? this.minDroppingInterval,
        maxDroppingInterval: maxDroppingInterval ?? this.maxDroppingInterval,
        minDroppingSpeed: minDroppingSpeed ?? this.minDroppingSpeed,
        maxDroppingSpeed: maxDroppingSpeed ?? this.maxDroppingSpeed,
        delay: delay ?? this.delay,
      );

  @override
  int get hashCode =>
      itemsInWave.hashCode ^
      dropDiversityList.hashCode ^
      minDroppingInterval.hashCode ^
      maxDroppingInterval.hashCode ^
      minDroppingSpeed.hashCode ^
      maxDroppingSpeed.hashCode ^
      delay.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wave &&
          runtimeType == other.runtimeType &&
          itemsInWave == other.itemsInWave &&
          dropDiversityList == other.dropDiversityList &&
          minDroppingInterval == other.minDroppingInterval &&
          maxDroppingInterval == other.maxDroppingInterval &&
          minDroppingSpeed == other.minDroppingSpeed &&
          maxDroppingSpeed == other.maxDroppingSpeed &&
          delay == other.delay;

  @override
  String toString() => 'Wave{itemsInWave: $itemsInWave, '
      'dropDiversityList: $dropDiversityList, '
      'minIteraval: $minDroppingInterval, '
      'maxInteval: $maxDroppingInterval, '
      'minSpeed: $minDroppingSpeed, '
      'maxSpeed: $maxDroppingSpeed, '
      'delay: $delay}';
}
