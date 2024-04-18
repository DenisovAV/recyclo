import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/audio/music_service.dart';
import 'package:flutter_game_challenge/audio/sounds.dart';
import 'package:flutter_game_challenge/settings/cubit/settings_state.dart';
import 'package:flutter_game_challenge/settings/settings.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsController _settingsController;
  final MusicService _musicService;

  SettingsCubit(
    this._settingsController,
    this._musicService,
  ) : super(
          SettingsState(
            isMusicEnabled: _settingsController.musicOn.value,
            isSoundEffectsEnabled: _settingsController.soundsOn.value,
          ),
        ) {
    _settingsController.musicOn.addListener(_updateSettings);
    _settingsController.soundsOn.addListener(_updateSettings);
  }

  void _updateSettings() {
    emit(
      SettingsState(
        isMusicEnabled: _settingsController.musicOn.value,
        isSoundEffectsEnabled: _settingsController.soundsOn.value,
      ),
    );
  }

  void toggleSoundsOn() async {
    await _settingsController.toggleSoundsOn();
    _musicService.playSound(Sounds.toggleSound);
  }

  void toggleMusicOn() {
    _musicService.playSound(Sounds.toggleSound);
    _settingsController.toggleMusicOn();
  }

  @override
  Future<void> close() {
    _settingsController.musicOn.removeListener(_updateSettings);
    _settingsController.soundsOn.removeListener(_updateSettings);
    return super.close();
  }
}
