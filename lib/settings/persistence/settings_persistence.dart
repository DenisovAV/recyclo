abstract class SettingsPersistence {
  Future<bool> getMusicOn({required bool defaultValue});

  Future<bool> getSoundsOn({required bool defaultValue});

  Future<void> saveMusicOn(bool value);

  Future<void> saveSoundsOn(bool value);
}