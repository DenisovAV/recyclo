import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/catcher_game/game.dart';
import 'package:flutter_game_challenge/menu/view/main_menu_page.dart';

class CatcherGamePage extends StatefulWidget {
  const CatcherGamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CatcherGamePage(),
    );
  }

  @override
  State<CatcherGamePage> createState() => _CatcherGamePageState();
}

class _CatcherGamePageState extends State<CatcherGamePage> {
  FlameGame? _game;

  @override
  Widget build(BuildContext context) {
    _game ??= CatcherGame();

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game!),
          SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: GameBackButton(
                    onPressed: _handleBackButton,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleBackButton() {
    Navigator.of(context).pop();
  }
}
