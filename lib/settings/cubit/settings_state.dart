import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isMusicEnabled;
  final bool isSoundEffectsEnabled;
  final bool isPenaltyEnabled;

  const SettingsState({
    required this.isMusicEnabled,
    required this.isSoundEffectsEnabled,
    required this.isPenaltyEnabled,
  });

  @override
  List<Object?> get props => [
        isMusicEnabled,
        isSoundEffectsEnabled,
        isPenaltyEnabled,
      ];
}
