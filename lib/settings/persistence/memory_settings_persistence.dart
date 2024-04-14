import 'settings_persistence.dart';

class MemoryOnlySettingsPersistence implements SettingsPersistence {
  bool musicOn = true;

  bool soundsOn = true;

  bool audioOn = true;

  String playerName = 'Player';

  @override
  Future<bool> getMusicOn({required bool defaultValue}) async => musicOn;

  @override
  Future<bool> getSoundsOn({required bool defaultValue}) async => soundsOn;

  @override
  Future<void> saveMusicOn(bool value) async => musicOn = value;

  @override
  Future<void> saveSoundsOn(bool value) async => soundsOn = value;
}
