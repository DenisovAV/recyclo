import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';
import 'package:flutter_game_challenge/game/finder/components/item.dart';

class FinderWorld extends World with HasGameReference {
  static const double kTopGap = 200;

  final List<String> itemTypes = [
    Assets.images.duck.path,
    Assets.images.cheese.path,
    Assets.images.cup.path,
    Assets.images.concrete.path,
    Assets.images.gamepad.path,
  ];

  @override
  Future<void> onLoad() async {
    await _loadImageAssets();

    final items = _generateItemsRandomly();
    final camera = game.camera;

    final image = Flame.images.fromCache(Assets.images.fog.path);
    final sprite = Sprite(
      image,
      srcPosition: Vector2(0, 0),
      srcSize: image.size,
    );
    final background = SpriteComponent(
      sprite: sprite,
      size: sprite.srcSize,
      position: Vector2(0, 0 + kTopGap),
      scale: Vector2.all(1),
    );

    add(background);
    await addAll(items);

    final playAreaSize = Vector2(4 * 256, 6 * 256 + kTopGap);
    final gameMidX = playAreaSize.x / 2;

    camera.viewfinder.visibleGameSize = playAreaSize;
    camera.viewfinder.position = Vector2(gameMidX, 0);
    camera.viewfinder.anchor = Anchor.topCenter;
  }

  Future<void> _loadImageAssets() async {
    Flame.images.prefix = '';
    await Flame.images.load(Assets.images.fog.path);
    await Flame.images.loadAll(itemTypes);
  }

  List<Item> _generateItemsRandomly() {
    final random = Random();
    const generatedListLength = 100;

    final generatedList = List.filled(
      generatedListLength,
      Item(
        position: Vector2(0, 0),
        spritePath: '',
      ),
    );

    for (var i = 0; i < generatedListLength; i++) {
      final randomInt = random.nextInt(itemTypes.length);
      final itemFromRandom = Item(
        position: Vector2(0, 0 + kTopGap), //Calculate offset
        spritePath: itemTypes[randomInt],
      );
      generatedList[i] = itemFromRandom;
    }

    return generatedList;
  }
}
