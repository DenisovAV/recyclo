import 'package:flutter_game_challenge/common/feature_type.dart';

extension FeatureTypeExtension on FeatureType {
  bool isEnabled() {
    switch (this) {
      case FeatureType.googleWallet:
        return true;
      default:
        return true;
    }
  }
}
