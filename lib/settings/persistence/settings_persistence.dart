abstract class SettingsPersistence {
  bool getMusicOn({required bool defaultValue});

  bool getSoundsOn({required bool defaultValue});

  Future<void> saveMusicOn(bool value);

  Future<void> saveSoundsOn(bool value);

  Future<void> initialize();
}
