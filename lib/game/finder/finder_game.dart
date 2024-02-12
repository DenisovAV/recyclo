import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_game_challenge/game/finder/components/item.dart';

class FinderGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final item = Item();

    world.add(item);
    final camera = CameraComponent(world: world);
    await addAll([camera]);

    return super.onLoad();
  }
}
