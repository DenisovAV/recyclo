import 'package:flutter/material.dart';
import 'package:recyclo/bootstrap.dart';
import 'package:recyclo/landing/index.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  bootstrap(LandingApp.new);
}
