import 'package:flutter/material.dart';

import 'persistence/settings_persistence.dart';

class SettingsController {
  final SettingsPersistence _store;

  ValueNotifier<bool> soundsOn = ValueNotifier(false);
  ValueNotifier<bool> musicOn = ValueNotifier(false);
  ValueNotifier<bool> penaltyOn = ValueNotifier(false);
  ValueNotifier<String?> currentLanguage = ValueNotifier(null);

  SettingsController(this._store) {
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

  Future<void> togglePenaltyOn() {
    penaltyOn.value = !penaltyOn.value;
    return _store.setPenalty(penaltyOn.value);
  }

  Future<void> changeLanguage(Locale locale) {
    currentLanguage.value = locale.languageCode;
    return _store.saveCurrentLocale(locale.languageCode);
  }

  void _loadStateFromPersistence() {
    soundsOn.value = _store.getSoundsOn(defaultValue: true);
    musicOn.value = _store.getMusicOn(defaultValue: true);
    penaltyOn.value = _store.getPenaltyFlag(defaultValue: true);
    currentLanguage.value = _store.getCurrentLocale();
  }
}
