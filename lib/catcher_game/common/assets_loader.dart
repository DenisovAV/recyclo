import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flutter_game_challenge/catcher_game/background/config.dart';
import 'package:flutter_game_challenge/catcher_game/main_scene/components.dart';

class AssetsLoader {
  factory AssetsLoader() => _instance;

  AssetsLoader._internal();

  static final AssetsLoader _instance = AssetsLoader._internal();

  Future<List<Image>> loadAssets() async =>
      Flame.images.loadAll(_getAssetsList());

  List<String> getAssets(RecycleType type) {
    var list = <String>[];
    switch (type) {
      case RecycleType.organic:
        list = _loadDropOrganic();
      case RecycleType.glass:
        list = _loadDropGlass();
      case RecycleType.plastic:
        list = _loadDropPlastic();
      case RecycleType.electric:
        list = _loadDropElectric();
      case RecycleType.paper:
        list = _loadDropPaper();
    }

    return list;
  }

  List<String> _getAssetsList() => List<String>.empty(growable: true)
    ..addAll([
      BackgroundConfig.sceneAsset,
      ButtonsContainerConfig.buttonPauseAnimatedAsset,
      ButtonsContainerConfig.buttonResetAnimatedAsset,
      TutorialContainerConfig.tutorialAsset,
      TutorialContainerConfig.tutorialButtonPlayAsset,
      ButtonsContainerConfig.buttonPauseAsset,
      ..._loadBoxes(),
      ..._loadDropGlass(),
      ..._loadDropOrganic(),
      ..._loadDropPaper(),
      ..._loadDropElectric(),
      ..._loadDropPlastic(),
    ]);

  List<String> _loadBoxes() {
    final list = <String>[];
    for (final box in RecycleType.values) {
      switch (box) {
        case RecycleType.organic:
          list.add('boxes/organic.png');
        case RecycleType.glass:
          list.add('boxes/glass.png');
        case RecycleType.plastic:
          list.add('boxes/plastic.png');
        case RecycleType.electric:
          list.add('boxes/electric.png');
        case RecycleType.paper:
          list.add('boxes/paper.png');
      }
    }
    return list;
  }

  List<String> _loadDropGlass() {
    final list = <String>[];
    for (var i = 0; i < 8; i++) {
      list.add('drops/glass/$i.png');
    }
    return list;
  }

  List<String> _loadDropOrganic() {
    final list = <String>[];
    for (var i = 0; i < 11; i++) {
      list.add('drops/organic/$i.png');
    }
    return list;
  }

  List<String> _loadDropPlastic() {
    final list = <String>[];
    for (var i = 0; i < 5; i++) {
      list.add('drops/plastic/$i.png');
    }
    return list;
  }

  List<String> _loadDropElectric() {
    final list = <String>[];
    for (var i = 0; i < 4; i++) {
      list.add('drops/electric/$i.png');
    }
    return list;
  }

  List<String> _loadDropPaper() {
    final list = <String>[];
    for (var i = 0; i < 5; i++) {
      list.add('drops/paper/$i.png');
    }
    return list;
  }
}
