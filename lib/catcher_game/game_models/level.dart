import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_game_challenge/catcher_game/game_models/wave.dart';

@immutable
class Level extends Equatable {
  const Level({
    required this.number,
    required this.waves,
  });

  final int number;
  final List<Wave> waves;

  @override
  String toString() => 'Level{number: $number, waves: $waves }';

  @override
  List<Object> get props => [number, waves];
}
