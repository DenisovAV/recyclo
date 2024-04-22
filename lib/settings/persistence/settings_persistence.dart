import 'package:recyclo/common.dart';

abstract class SettingsPersistence {
  bool getMusicOn({required bool defaultValue});

  bool getSoundsOn({required bool defaultValue});

  bool getPenaltyFlag({bool defaultValue = false});

  String? getCurrentLocale();

  GameDifficultyType getGameDifficulty({
    required GameDifficultyType defaultValue,
  });

  Future<void> saveCurrentLocale(String value);

  Future<void> saveMusicOn({required bool isMusicOn});

  Future<void> setPenalty({required bool value});

  Future<void> saveSoundsOn({required bool soundsOn});

  Future<void> setGameDifficulty(GameDifficultyType difficulty);

  Future<void> initialize();
}
