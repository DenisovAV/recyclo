abstract class SettingsPersistence {
  bool getMusicOn({required bool defaultValue});

  bool getSoundsOn({required bool defaultValue});

  bool getPenaltyFlag({bool defaultValue = false});

  Future<void> saveMusicOn(bool value);

  Future<void> setPenalty(bool value);

  Future<void> saveSoundsOn(bool value);

  Future<void> initialize();
}
