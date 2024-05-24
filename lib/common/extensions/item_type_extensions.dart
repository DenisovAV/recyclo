import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';

extension ItemTypeExtension on ItemType {
  Image image({
    Size size = const Size.square(32),
  }) =>
      switch (this) {
        ItemType.organic => Assets.images.organic.image(
            width: size.width,
            height: size.height,
          ),
        ItemType.plastic => Assets.images.plastic.image(
            width: size.width,
            height: size.height,
          ),
        ItemType.glass => Assets.images.glass.image(
            width: size.width,
            height: size.height,
          ),
        ItemType.paper => Assets.images.paper.image(
            width: size.width,
            height: size.height,
          ),
        ItemType.electronic => Assets.images.energy.image(
            width: size.width,
            height: size.height,
          ),
      };

  String get iconPath => switch (this) {
        ItemType.organic => Assets.images.organic.path,
        ItemType.plastic => Assets.images.plastic.path,
        ItemType.glass => Assets.images.glass.path,
        ItemType.paper => Assets.images.paper.path,
        ItemType.electronic => Assets.images.energy.path,
      };

  Color get color => switch (this) {
        ItemType.organic => FlutterGameChallengeColors.categoryGreen,
        ItemType.plastic => FlutterGameChallengeColors.categoryOrange,
        ItemType.glass => FlutterGameChallengeColors.categoryViolet,
        ItemType.paper => FlutterGameChallengeColors.categoryPink,
        ItemType.electronic => FlutterGameChallengeColors.categoryYellow,
      };
}
