import 'dart:ui';

import 'package:recyclo/common/assets/assets.gen.dart';
import 'package:recyclo/common/assets/colors.gen.dart';
import 'package:recyclo/common/entities/item_type.dart';

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
