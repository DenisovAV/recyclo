import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/app/app.dart';
import 'package:flutter_game_challenge/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bootstrap(() => const App());
}
