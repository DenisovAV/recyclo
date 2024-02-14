import 'package:flutter/foundation.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/model/wave.dart';

@immutable
class Level {
  Level({int? number, List<Wave>? waves, bool? extraDifficulty})
      : number = number ?? 0,
        waves = waves ?? [const Wave()],
        extraDifficulty = extraDifficulty ?? false;

  final int number;
  final List<Wave> waves;
  final bool extraDifficulty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Level &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          waves == other.waves &&
          extraDifficulty == other.extraDifficulty;

  @override
  int get hashCode => number.hashCode ^ waves.hashCode ^ extraDifficulty.hashCode;

  @override
  String toString() => 'Level{number: $number, waves: $waves, extra: $extraDifficulty }';
}
