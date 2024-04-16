import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flutter_game_challenge/common.dart';

class AssetsLoader {
  const AssetsLoader({
    required Images images,
  }) : _images = images;

  final Images _images;

  Future<List<Image>> loadAssets() => _images.loadAll(_gameAssets());

  List<String> getAssetsListByItemType(ItemType type) {
    var list = <String>[];
    switch (type) {
      case ItemType.organic:
        list = _organicAssets();
      case ItemType.glass:
        list = _glassAssets();
      case ItemType.plastic:
        list = _plasticAssets();
      case ItemType.electronic:
        list = _electricAssets();
      case ItemType.paper:
        list = _paperAssets();
    }

    return list;
  }

  List<String> _gameAssets() => [
        Assets.images.catcher.bg.bg.path,
        Assets.images.catcher.animations.pause.path,
        Assets.images.catcher.animations.reset.path,
        Assets.images.catcher.tutorial.tutorial.path,
        Assets.images.catcher.tutorial.play.path,
        Assets.images.catcher.button.play.path,
        ..._boxAssets(),
        ..._glassAssets(),
        ..._organicAssets(),
        ..._paperAssets(),
        ..._electricAssets(),
        ..._plasticAssets(),
        Assets.images.fog.path,
        Assets.images.fogDark.path,
        Assets.images.holeMask.path,
        Assets.images.hole.path,
        Assets.images.clicker.images.cloud.path,
      ];

  List<String> _boxAssets() => Assets.images.catcher.boxes.values.paths;

  List<String> _glassAssets() => Assets.images.catcher.drops.glass.values.paths;

  List<String> _organicAssets() =>
      Assets.images.catcher.drops.organic.values.paths;

  List<String> _plasticAssets() =>
      Assets.images.catcher.drops.plastic.values.paths;

  List<String> _electricAssets() =>
      Assets.images.catcher.drops.electric.values.paths;

  List<String> _paperAssets() => Assets.images.catcher.drops.paper.values.paths;
}

extension on List<AssetGenImage> {
  List<String> get paths => map((asset) => asset.path).toList();
}
