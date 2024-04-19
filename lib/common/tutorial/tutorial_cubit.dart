import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recyclo/common/tutorial/local_data_repository.dart';

part 'tutorial_state.dart';

class TutorialCubit extends Cubit<TutorialState> {
  TutorialCubit({required LocalDataRepository localDataRepository})
      : _localDataRepository = localDataRepository,
        super(TutorialState(
          isTutorialShown: localDataRepository.isTutorialShown,
          isTutorialShownBefore: localDataRepository.isTutorialShown,
        ));

  final LocalDataRepository _localDataRepository;

  void tutorialIsShown() {
    emit(TutorialState(
        isTutorialShown: true,
        isTutorialShownBefore: state.isTutorialShownBefore));

    _localDataRepository.tutorialIsShown();
  }
}
