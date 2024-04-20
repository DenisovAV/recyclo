import 'package:flutter/material.dart';

class RecycloLanguage {
  final Locale locale;
  final String localeName;

  RecycloLanguage({
    required this.locale,
    required this.localeName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecycloLanguage &&
          runtimeType == other.runtimeType &&
          locale == other.locale &&
          localeName == other.localeName;

  @override
  int get hashCode => locale.hashCode ^ localeName.hashCode;
}
