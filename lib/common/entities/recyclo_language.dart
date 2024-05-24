import 'package:flutter/material.dart';

@immutable
class RecycloLanguage {
  const RecycloLanguage({
    required this.locale,
    required this.localeName,
  });
  final Locale locale;
  final String localeName;

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
