import 'package:equatable/equatable.dart';
import 'package:flutter_game_challenge/common/entities/recyclo_language.dart';

class SettingsState extends Equatable {
  final bool isMusicEnabled;
  final bool isSoundEffectsEnabled;
  final RecycloLanguage currentLanguage;

  const SettingsState({
    required this.isMusicEnabled,
    required this.isSoundEffectsEnabled,
    required this.currentLanguage,
  });

  @override
  List<Object?> get props => [isMusicEnabled, isSoundEffectsEnabled, currentLanguage];
}
