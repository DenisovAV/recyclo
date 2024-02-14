import 'package:flutter/foundation.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components/fallen/recycle_type.dart';

@immutable
class Drop {
  const Drop({
    required this.type,
    int? varietyBounder,
  }) : varietyBounder = varietyBounder ?? 1;

  final RecycleType type;
  final int varietyBounder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Drop &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          varietyBounder == other.varietyBounder;

  @override
  int get hashCode => type.hashCode ^ varietyBounder.hashCode;

  @override
  String toString() => 'Drop{dropType: $type, varietyBounder: $varietyBounder}';
}
