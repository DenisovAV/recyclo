import 'package:equatable/equatable.dart';
import 'package:recyclo/common.dart';

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
