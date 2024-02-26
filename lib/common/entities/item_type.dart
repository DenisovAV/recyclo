import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/common.dart';

enum ItemType {
  electronic,
  glass,
  organic,
  paper,
  plastic;
}

extension ItemTypeExtension on ItemType {
  Image image({
    Size size = const Size.square(32),
  }) {
    switch (this) {
      case ItemType.electronic:
        return Assets.images.energy.image(
          width: size.width,
          height: size.height,
        );
      case ItemType.glass:
        return Assets.images.glass.image(
          width: size.width,
          height: size.height,
        );
      case ItemType.organic:
        return Assets.images.organic.image(
          width: size.width,
          height: size.height,
        );
      case ItemType.paper:
        return Assets.images.paper.image(
          width: size.width,
          height: size.height,
        );
      case ItemType.plastic:
        return Assets.images.plastic.image(
          width: size.width,
          height: size.height,
        );
    }
  }

  Color color() {
    return switch (this) {
      ItemType.electronic => FlutterGameChallengeColors.categoryPink,
      ItemType.glass => FlutterGameChallengeColors.categoryOrange,
      ItemType.organic => FlutterGameChallengeColors.categoryGreen,
      ItemType.paper => FlutterGameChallengeColors.categoryYellow,
      ItemType.plastic => FlutterGameChallengeColors.categoryViolet,
    };
  }
}
