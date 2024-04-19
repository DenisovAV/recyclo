import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/audio/music_service.dart';
import 'package:recyclo/audio/sounds.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/settings/cubit/settings_state.dart';
import 'package:recyclo/settings/settings.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._settingsController,
    this._musicService,
  ) : super(
          SettingsState(
            isMusicEnabled: _settingsController.musicOn.value,
            isSoundEffectsEnabled: _settingsController.soundsOn.value,
            isPenaltyEnabled: _settingsController.penaltyOn.value,
            gameDifficulty: _settingsController.gameDifficulty.value,
          ),
        ) {
    _settingsController.musicOn.addListener(_updateSettings);
    _settingsController.soundsOn.addListener(_updateSettings);
    _settingsController.penaltyOn.addListener(_updateSettings);
    _settingsController.gameDifficulty.addListener(_updateSettings);
  }

  final SettingsController _settingsController;
  final MusicService _musicService;

  void _updateSettings() {
    emit(
      SettingsState(
        isMusicEnabled: _settingsController.musicOn.value,
        isSoundEffectsEnabled: _settingsController.soundsOn.value,
        isPenaltyEnabled: _settingsController.penaltyOn.value,
        gameDifficulty: _settingsController.gameDifficulty.value,
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

  void togglePenalty() {
    _settingsController.togglePenaltyOn();
  }

  void setGameDifficulty(GameDifficultyType difficulty) {
    _settingsController.setGameDifficulty(difficulty);
  }

  @override
  Future<void> close() {
    _settingsController.musicOn.removeListener(_updateSettings);
    _settingsController.soundsOn.removeListener(_updateSettings);
    _settingsController.penaltyOn.removeListener(_updateSettings);
    _settingsController.gameDifficulty.removeListener(_updateSettings);
    return super.close();
  }
}
