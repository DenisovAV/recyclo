import 'package:equatable/equatable.dart';
import 'package:recyclo/common.dart';

class SettingsState extends Equatable {
  final bool isMusicEnabled;
  final bool isSoundEffectsEnabled;
  final RecycloLanguage currentLanguage;
  final bool isPenaltyEnabled;

  const SettingsState({
    required this.isMusicEnabled,
    required this.isSoundEffectsEnabled,
    required this.currentLanguage,
    required this.isPenaltyEnabled,
  });

  @override
  List<Object?> get props => [isMusicEnabled, isSoundEffectsEnabled, currentLanguage, isPenaltyEnabled];
}
