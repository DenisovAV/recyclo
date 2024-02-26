import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter_game_challenge/game/finder/finder_world.dart';

class FinderGame extends FlameGame<FinderWorld> {
  FinderGame() : super(world: FinderWorld());

  @override
  Color backgroundColor() => Color.fromARGB(255, 114, 169, 205);
}
