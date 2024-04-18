import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/common/entities/recyclo_language.dart';
import 'package:flutter_game_challenge/settings/settings.dart';

class AppLocalizationsProvider extends ChangeNotifier {
  final SettingsController _controller;
  RecycloLanguage? _locale;

  AppLocalizationsProvider(this._controller) {
    _controller.currentLanguage.addListener(getLocale);
  }

  RecycloLanguage get currentLanguage {
    if (_locale != null) {
      return _locale!;
    }

    return supportLocales.first.toAppLanguage();
  }

  void getLocale() {
    final localeCode = _controller.currentLanguage.value ?? '';
    final language = Locale(localeCode).toAppLanguage();
    if (isSupportedLocale(language)) {
      _locale = language;
      notifyListeners();
    }
  }

  List<Locale> get supportLocales => AppLocalizations.supportedLocales;

  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      AppLocalizations.localizationsDelegates;

  bool isSupportedLocale(RecycloLanguage lang) => supportLocales.contains(lang.locale);
}
