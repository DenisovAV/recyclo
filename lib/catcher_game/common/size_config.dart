import 'package:flame/components.dart';
import 'package:flutter_game_challenge/catcher_game/common/config.dart';

class SizeConfig extends Component {
  double _tileSize = 0;

  double get tileSize => _tileSize;

  @override
  void onGameResize(Vector2 size) {
    _tileSize = size.toSize().width / DebugBalancingTableConfig.tileProportions;
    super.onGameResize(size);
  }
}
