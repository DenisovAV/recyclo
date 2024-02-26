import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';

enum TrashType {
  organic,
  paper,
  glass,
  electric,
  plastic;

  String get iconPath {
    switch (this) {
      case TrashType.organic:
        return Assets.images.organic.path;
      case TrashType.paper:
        return Assets.images.paper.path;
      case TrashType.electric:
        return Assets.images.energy.path;
      case TrashType.plastic:
        return Assets.images.plastic.path;
      case TrashType.glass:
        return Assets.images.glass.path;
    }
  }

  List<AssetGenImage> get assets {
    switch (this) {
      case TrashType.electric:
        return Assets.images.catcher.drops.electric.values;
      case TrashType.plastic:
        return Assets.images.catcher.drops.plastic.values;
      case TrashType.paper:
        return Assets.images.catcher.drops.paper.values;
      case TrashType.organic:
        return Assets.images.catcher.drops.organic.values;
      case TrashType.glass:
        return Assets.images.catcher.drops.glass.values;
    }
  }

  ItemType get asItemType {
    switch (this) {
      case TrashType.organic:
        return ItemType.organic;
      case TrashType.paper:
        return ItemType.paper;
      case TrashType.electric:
        return ItemType.electronic;
      case TrashType.plastic:
        return ItemType.plastic;
      case TrashType.glass:
        return ItemType.glass;
    }
  }

  Color get color {
    switch (this) {
      case TrashType.organic:
        return FlutterGameChallengeColors.categoryGreen;
      case TrashType.paper:
        return FlutterGameChallengeColors.categoryPink;
      case TrashType.electric:
        return FlutterGameChallengeColors.categoryYellow;
      case TrashType.plastic:
        return FlutterGameChallengeColors.categoryOrange;
      case TrashType.glass:
        return FlutterGameChallengeColors.categoryViolet;
    }
  }
}

class TrashItemData {
  const TrashItemData({
    required this.name,
    required this.classification,
    required this.assetPath,
    this.sizeMultiplier = 1.0,
  });

  final String name;
  final String assetPath;
  final TrashType classification;
  final double sizeMultiplier;
}

class TrashBin {
  TrashBin()
      : trash = _loadBin(),
        _random = Random();

  final List<TrashItemData> trash;
  final Random _random;

  TrashItemData get randomTrash {
    return trash[_random.nextInt(trash.length)];
  }

  static List<TrashItemData> _loadBin() {
    final trash = <TrashItemData>[];
    for (final trashType in TrashType.values) {
      trash.addAll(
        trashType.assets.map(
          (e) => TrashItemData(
            name: e.keyName,
            classification: trashType,
            assetPath: e.path,
          ),
        ),
      );
    }
    return trash;
  }

  static final List<TrashItemData> electricType =
      Assets.images.catcher.drops.electric.values
          .map(
            (e) => TrashItemData(
              name: e.keyName,
              classification: TrashType.electric,
              assetPath: e.path,
            ),
          )
          .toList();

  static final List<TrashItemData> plastic =
      Assets.images.catcher.drops.plastic.values
          .map(
            (e) => TrashItemData(
              name: e.keyName,
              classification: TrashType.electric,
              assetPath: e.path,
            ),
          )
          .toList();
}
