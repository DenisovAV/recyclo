import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isMusicEnabled;
  final bool isSoundEffectsEnabled;

  const SettingsState({
    required this.isMusicEnabled,
    required this.isSoundEffectsEnabled,
  });

  @override
  List<Object?> get props => [
        isMusicEnabled,
        isSoundEffectsEnabled,
      ];
}
