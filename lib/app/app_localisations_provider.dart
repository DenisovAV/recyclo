import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/settings/settings.dart';

class AppLocalizationsProvider extends ChangeNotifier {

  AppLocalizationsProvider(this._controller) {
    _controller.currentLanguage.addListener(getLocale);
  }
  final SettingsController _controller;
  RecycloLanguage? _locale;

  RecycloLanguage get currentLanguage {
    if (_locale != null) {
      return _locale!;
    }

    return supportLocales.first.toAppLanguage();
  }

  void getLocale() {
    final localeCode = _controller.currentLanguage.value;

    if(localeCode == null) return;

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
