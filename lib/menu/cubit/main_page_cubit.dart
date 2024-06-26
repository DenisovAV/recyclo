import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/audio/music_service.dart';
import 'package:recyclo/audio/songs.dart';
import 'package:recyclo/audio/sounds.dart';
import 'package:recyclo/menu/cubit/main_page_state.dart';

typedef MainPageGameNavigationCallback = Future<void> Function(
  GameType gameType,
);

enum GameType {
  catcher,
  clicker,
  finder,
}

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit(
    this._musicService,
  ) : super(MainPageInitialState()) {
    _initialize();
  }

  final MusicService _musicService;

  Future<void> _initialize() async {
    await _musicService.stopMusic();
    await _musicService.playSong(Songs.mainMenuAmbient);
  }

  void navigateToChooseGame() {
    _musicService.playSound(Sounds.buttonTap);
    emit(MainPageChooseGameState());
  }

  void navigateToMainPage() {
    _musicService.playSound(Sounds.buttonTap);
    emit(MainPageInitialState());
  }

  void navigateToArtifacts() {
    _musicService.playSound(Sounds.buttonTap);
    emit(MainPageArtifactsState());
  }

  void navigateToArtifactDetails() {
    _musicService.playSound(Sounds.buttonTap);
    emit(MainPageArtifactDetailsState());
  }

  void navigateToTutorial() {
    _musicService.playSound(Sounds.buttonTap);
    emit(MainPageTutorialState());
  }

  void navigateToSettings() {
    _musicService.playSound(Sounds.buttonTap);
    emit(MainPageSettingsState());
  }

  Future<void> navigateToCatcherGame(
    MainPageGameNavigationCallback context,
  ) async {
    await _musicService.playSound(Sounds.buttonTap);
    await _musicService.playSong(Songs.catcherTheme);

    await context(GameType.catcher);

    await _musicService.playSong(Songs.mainMenuAmbient);
  }

  Future<void> navigateToClickerGame(
    MainPageGameNavigationCallback context,
  ) async {
    await _musicService.playSound(Sounds.buttonTap);
    await _musicService.playSong(Songs.clickerTheme);

    await context(GameType.clicker);

    await _musicService.playSong(Songs.mainMenuAmbient);
  }

  Future<void> navigateToFinderGame(
    MainPageGameNavigationCallback onGameNavigate,
  ) async {
    await _musicService.playSound(Sounds.buttonTap);
    await _musicService.playSong(Songs.finderTheme);

    await onGameNavigate(GameType.finder);

    await _musicService.playSong(Songs.mainMenuAmbient);
  }

  @override
  Future<void> close() async {
    await _musicService.stopMusic();
    return super.close();
  }
}
