import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:recyclo/settings/settings.dart';

class MusicService {
  MusicService(
    this._createAudioPlayer,
    this._settingsController,
  )   : _isMusicEnabled = _settingsController.musicOn.value,
        _isSoundsEnabled = _settingsController.soundsOn.value,
        _musicPlayer = _createAudioPlayer() {
    _settingsController.musicOn.addListener(_updateIsMusicEnabled);
    _settingsController.soundsOn.addListener(_updateIsSoundsEnabled);
  }

  final AudioPlayer _musicPlayer;
  final AudioPlayer Function() _createAudioPlayer;
  final SettingsController _settingsController;
  bool _isMusicEnabled;
  bool _isSoundsEnabled;
  AssetSource? _latestSource;

  StreamSubscription<void>? _songCompletedSubscription;

  Future<void> stopMusic() {
    return _musicPlayer.stop();
  }

  Future<void> playSound(AssetSource source) async {
    if (!_isSoundsEnabled) {
      return;
    }

    final tempPlayer = _createAudioPlayer();
    await tempPlayer.play(source);

    StreamSubscription<void>? tempSubscription;
    tempSubscription = tempPlayer.onPlayerComplete.listen((event) {
      tempSubscription?.cancel();
      tempPlayer.dispose();
    });
  }

  void handleLifecycleStateChange(AppLifecycleState appState) {
    if (_isMusicEnabled) {
      appState != AppLifecycleState.resumed
          ? _musicPlayer.pause()
          : _musicPlayer.resume();
    }
  }

  void _updateIsSoundsEnabled() {
    _isSoundsEnabled = _settingsController.soundsOn.value;
  }

  void _updateIsMusicEnabled() {
    final newValue = _settingsController.musicOn.value;

    if (newValue == _isMusicEnabled) return;

    if (newValue) {
      _isMusicEnabled = newValue;
      if (_latestSource != null) {
        playSong(_latestSource!);
      }
    }

    if (!newValue) {
      _isMusicEnabled = newValue;
      _musicPlayer.stop();
    }
  }

  Future<void> playSong(AssetSource song) async {
    _latestSource = song;

    if (!_isMusicEnabled) {
      return;
    }

    await _musicPlayer.stop();
    await _musicPlayer.play(song);
    await _songCompletedSubscription?.cancel();
    _songCompletedSubscription =
        _musicPlayer.onPlayerComplete.listen((event) async {
      await _musicPlayer.stop();
      await _musicPlayer.play(song);
    });
  }

  void dispose() {
    _songCompletedSubscription?.cancel();
    _musicPlayer.dispose();
  }
}
