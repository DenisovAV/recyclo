import 'package:flutter/foundation.dart';
import 'package:flutter_game_challenge/common.dart';

@immutable
class Drop {
  const Drop({
    required this.type,
    int? varietyBounder,
  }) : varietyBounder = varietyBounder ?? 1;

  final ItemType type;
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
