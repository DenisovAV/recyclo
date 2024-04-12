import 'package:flutter/foundation.dart';

import 'persistence/local_storage_settings_persistence.dart';
import 'persistence/settings_persistence.dart';

class SettingsController {
  final SettingsPersistence _store;

  ValueNotifier<bool> soundsOn = ValueNotifier(false);
  ValueNotifier<bool> musicOn = ValueNotifier(false);

  SettingsController({SettingsPersistence? store})
      : _store = store ?? LocalStorageSettingsPersistence() {
    _loadStateFromPersistence();
  }

  Future<void> toggleMusicOn() {
    musicOn.value = !musicOn.value;
    return _store.saveMusicOn(musicOn.value);
  }

  Future<void> toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    return _store.saveSoundsOn(soundsOn.value);
  }

  Future<void> _loadStateFromPersistence() {
    return Future.wait([
      _store
          .getSoundsOn(defaultValue: true)
          .then((value) => soundsOn.value = value),
      _store
          .getMusicOn(defaultValue: true)
          .then((value) => musicOn.value = value),
    ]);
  }
}
