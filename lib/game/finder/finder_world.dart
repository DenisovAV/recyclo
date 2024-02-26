import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';

import 'package:flutter_game_challenge/game/finder/components/item.dart';
import 'package:flutter_game_challenge/game/finder/components/overlay.dart';

class FinderWorld extends World with HasGameReference, HasCollisionDetection {
  static const double kTopGap = 200;
  static const double _kPlayAreaHeight = 6 * 256 + kTopGap;
  static const double _kPlayAreaWidth = 4 * 256;

  final List<String> _itemTypes = [
    Assets.images.duck.path,
    Assets.images.cheese.path,
    Assets.images.cup.path,
    Assets.images.concrete.path,
    Assets.images.gamepad.path,
  ];

  List<Item> collectedItems = List.empty(growable: true);

  @override
  Future<void> onLoad() async {
    final playAreaSize = Vector2(_kPlayAreaWidth, _kPlayAreaHeight);
    _setupCamera(playAreaSize);

    await _loadImageAssets();
    final items = _generateItemsRandomly();

    add(
      SpriteComponent.fromImage(
        Flame.images.fromCache(Assets.images.fog.path),
        srcPosition: Vector2(0, -kTopGap),
        srcSize: Vector2(1080, 1920),
        priority: 1,
      )..decorator =
          PaintDecorator.tint(const Color.fromARGB(84, 158, 158, 158)),
    );
    await addAll(items);
    add(
      OverlayFog()
        ..priority = 4
        ..size = playAreaSize,
    );
  }

  Future<void> _loadImageAssets() async {
    Flame.images.prefix = '';
    await Flame.images.load(Assets.images.fog.path);
    await Flame.images.load(Assets.images.holeMask.path);
    await Flame.images.loadAll(_itemTypes);
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
      final randomInt = random.nextInt(_itemTypes.length);
      final itemFromRandom = Item(
        position: Vector2(0, kTopGap),
        spritePath: _itemTypes[randomInt],
      )..priority = 2;
      generatedList[i] = itemFromRandom;
    }

    return generatedList;
  }

  void _setupCamera(Vector2 playAreaSize) {
    final gameMidX = playAreaSize.x / 2;
    final camera = game.camera;
    camera.viewfinder.visibleGameSize = playAreaSize;
    camera.viewfinder.position = Vector2(gameMidX, 0);
    camera.viewfinder.anchor = Anchor.topCenter;
  }
}
