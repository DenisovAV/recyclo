import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/game/finder/view/finder_page.dart';
import 'package:flutter_game_challenge/game/game.dart';
import 'package:flutter_game_challenge/title/title.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const MainMenuPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuItem(
                text: l10n.mainMenuGamesItemTitle,
                onTap: () {
                  Navigator.of(context).push(GamePage.route());
                },
              ),
              MenuItem(
                text: l10n.mainMenuArtifactsItemTitle,
                onTap: () {
                  Navigator.of(context).push(FinderPage.route());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 50,
    );

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
