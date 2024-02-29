import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitialState());

  void navigateToChooseGame() {
    emit(MainPageChooseGameState());
  }

  void navigateToMainPage() {
    emit(MainPageInitialState());
  }

  void navigateToArtifacts() {
    emit(MainPageArtifactsState());
  }

  void navigateToSettings() {
    emit(MainPageSettingsState());
  }

   void navigateToArtifactDetails() {
    emit(MainPageArtifactDetailsState());
  }
}
