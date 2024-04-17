import 'package:shared_preferences/shared_preferences.dart';

import 'settings_persistence.dart';

class LocalStorageSettingsPersistence extends SettingsPersistence {
  late final SharedPreferences _sharedPreferences;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<bool> getMusicOn({required bool defaultValue}) async {
    return _sharedPreferences.getBool('musicOn') ?? defaultValue;
  }

  @override
  Future<bool> getSoundsOn({required bool defaultValue}) async {
    return _sharedPreferences.getBool('soundsOn') ?? defaultValue;
  }

  @override
  Future<void> saveMusicOn(bool value) async {
    await _sharedPreferences.setBool('musicOn', value);
  }

  @override
  Future<void> saveSoundsOn(bool value) async {
    await _sharedPreferences.setBool('soundsOn', value);
  }
}
