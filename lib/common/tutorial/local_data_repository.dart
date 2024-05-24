import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDataRepository {
  late final SharedPreferences _sharedPreferences;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  bool get isTutorialShown =>
      _sharedPreferences.getBool(_LocalDataRepositoryKeys.tutorialKey) ?? false;

  void tutorialIsShown() {
    _sharedPreferences.setBool(_LocalDataRepositoryKeys.tutorialKey, true);
  }
}

class _LocalDataRepositoryKeys {
  static const tutorialKey = 'localDataRepositoryIsTutorialShown';
}
