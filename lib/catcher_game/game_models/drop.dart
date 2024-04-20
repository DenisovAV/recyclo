import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:recyclo/common.dart';

@immutable
class Drop extends Equatable {
  const Drop({
    required this.type,
    int? varietyBounder,
  }) : varietyBounder = varietyBounder ?? 1;

  final ItemType type;
  final int varietyBounder;

  @override
  String toString() => 'Drop{dropType: $type, varietyBounder: $varietyBounder}';

  @override
  List<Object> get props => [type, varietyBounder];
}
