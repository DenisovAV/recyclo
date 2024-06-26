import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';

extension LocaleExtension on Locale {
  RecycloLanguage toAppLanguage() {
    switch (languageCode) {
      case 'ja':
        return RecycloLanguage(locale: this, localeName: '日本語');
      default:
        return RecycloLanguage(locale: this, localeName: 'English');
    }
  }
}

extension AppLocalisationExtension on AppLocalizations {
  RecycloLanguage toAppLanguage() {
    switch (localeName) {
      case 'ja':
        return RecycloLanguage(locale: Locale(localeName), localeName: '日本語');
      default:
        return RecycloLanguage(locale: Locale(localeName), localeName: 'English');
    }
  }
}
