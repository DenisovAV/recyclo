import 'package:flutter_game_challenge/clicker_game/game_models/trash_type.dart';

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
