import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/app/app_localisations_provider.dart';
import 'package:recyclo/audio/music_service.dart';
import 'package:recyclo/audio/sounds.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/settings/cubit/settings_state.dart';
import 'package:recyclo/settings/settings.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsController _settingsController;
  final MusicService _musicService;
  final AppLocalizationsProvider _localisationsProvider;

  SettingsCubit(
    this._settingsController,
    this._musicService,
    this._localisationsProvider
  ) : super(
          SettingsState(
            isMusicEnabled: _settingsController.musicOn.value,
            isSoundEffectsEnabled: _settingsController.soundsOn.value,
            currentLanguage: _localisationsProvider.currentLanguage,
            isPenaltyEnabled: _settingsController.penaltyOn.value,
          ),
        ) {
    _settingsController.musicOn.addListener(_updateSettings);
    _settingsController.soundsOn.addListener(_updateSettings);
    _settingsController.penaltyOn.addListener(_updateSettings);
  }

  void _updateSettings() {
    emit(
      SettingsState(
        isMusicEnabled: _settingsController.musicOn.value,
        isSoundEffectsEnabled: _settingsController.soundsOn.value,
        currentLanguage: _localisationsProvider.currentLanguage,
        isPenaltyEnabled: _settingsController.penaltyOn.value,
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

  void changeLocale(RecycloLanguage? language) {
    if(language != null && _localisationsProvider.isSupportedLocale(language))
    _settingsController.changeLanguage(language.locale);
  }

  void togglePenalty() {
    _settingsController.togglePenaltyOn();
  }

  @override
  Future<void> close() {
    _settingsController.musicOn.removeListener(_updateSettings);
    _settingsController.soundsOn.removeListener(_updateSettings);
    _settingsController.penaltyOn.removeListener(_updateSettings);
    return super.close();
  }
}
