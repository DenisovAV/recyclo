abstract class SettingsPersistence {
  bool getMusicOn({required bool defaultValue});

  bool getSoundsOn({required bool defaultValue});

  String? getCurrentLocale();

  Future<void> saveCurrentLocale(String value);

  Future<void> saveMusicOn(bool value);

  Future<void> saveSoundsOn(bool value);

  Future<void> initialize();


}
