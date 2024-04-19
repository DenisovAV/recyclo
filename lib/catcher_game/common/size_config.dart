import 'package:flame/components.dart';
import 'package:recyclo/catcher_game/common/config.dart';

class SizeConfig extends Component {
  SizeConfig(this._gameScale);

  final AccessibilityGameScaleType _gameScale;

  double _tileSize = 0;

  double get tileSize => _tileSize;

  @override
  void onGameResize(Vector2 size) {
    _tileSize = size.toSize().width / _gameScale.denominator;
    super.onGameResize(size);
  }
}

extension on AccessibilityGameScaleType {
  double get denominator => switch (this) {
        AccessibilityGameScaleType.small => 9.0,
        AccessibilityGameScaleType.medium => 8.0,
        AccessibilityGameScaleType.large => 7.0,
      };
}
