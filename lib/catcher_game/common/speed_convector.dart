import 'package:flutter_game_challenge/catcher_game/common/config.dart';

extension SpeedConvectorExtension on double {
  double rangeToSpeed() {
    final i = (this - DebugBalancingTableConfig.minSpeedRange) /
            (DebugBalancingTableConfig.maxSpeedRange - DebugBalancingTableConfig.minSpeedRange) *
            (DebugBalancingTableConfig.maxSpeed - DebugBalancingTableConfig.minSpeed) +
        DebugBalancingTableConfig.minSpeed;

    return i;
  }

  double speedToRange() {
    final i = (this - DebugBalancingTableConfig.minSpeed) /
            (DebugBalancingTableConfig.maxSpeed - DebugBalancingTableConfig.minSpeed) *
            (DebugBalancingTableConfig.maxSpeedRange - DebugBalancingTableConfig.minSpeedRange) +
        DebugBalancingTableConfig.minSpeedRange;

    return i.roundToDouble();
  }
}
