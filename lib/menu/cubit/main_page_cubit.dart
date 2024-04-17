import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/audio/music_service.dart';
import 'package:flutter_game_challenge/audio/songs.dart';
import 'package:flutter_game_challenge/audio/sounds.dart';
import 'package:flutter_game_challenge/catcher_game/catcher_game_page.dart';
import 'package:flutter_game_challenge/clicker_game/clicker_game_page.dart';
import 'package:flutter_game_challenge/finder_game/finder_game_page.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  final MusicService _musicService;

  MainPageCubit(
    this._musicService,
  ) : super(MainPageInitialState()) {
    _initialize();
  }

  void _initialize() async {
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

  void navigateToCatcherGame(BuildContext context) async {
    await _musicService.playSound(Sounds.buttonTap);
    await _musicService.playSong(Songs.catcherTheme);

    await Navigator.of(context).push<void>(CatcherGamePage.route());

    await _musicService.playSong(Songs.mainMenuAmbient);
  }

  void navigateToClickerGame(BuildContext context) async {
    await _musicService.playSound(Sounds.buttonTap);
    await _musicService.playSong(Songs.clickerTheme);

    await Navigator.of(context).push<void>(ClickerGamePage.route());

    await _musicService.playSong(Songs.mainMenuAmbient);
  }

  void navigateToFinderGame(BuildContext context) async {
    await _musicService.playSound(Sounds.buttonTap);
    await _musicService.playSong(Songs.finderTheme);

    await Navigator.of(context).push<void>(FinderGamePage.route());

    await _musicService.playSong(Songs.mainMenuAmbient);
  }

  @override
  Future<void> close() async {
    await _musicService.stopMusic();
    return super.close();
  }
}
