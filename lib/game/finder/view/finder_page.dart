
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/game/finder/finder_game.dart';

class FinderPage extends StatelessWidget {
  const FinderPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const FinderPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = FinderGame();
    return GameWidget(game: game);
  }
}
