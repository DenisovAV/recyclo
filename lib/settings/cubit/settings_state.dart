import 'package:equatable/equatable.dart';
import 'package:recyclo/common.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.isMusicEnabled,
    required this.isSoundEffectsEnabled,
    required this.isPenaltyEnabled,
    required this.gameDifficulty,
  });

  final bool isMusicEnabled;
  final bool isSoundEffectsEnabled;
  final bool isPenaltyEnabled;
  final GameDifficultyType gameDifficulty;

  @override
  List<Object> get props => [
        isMusicEnabled,
        isSoundEffectsEnabled,
        isPenaltyEnabled,
        gameDifficulty,
      ];
}
