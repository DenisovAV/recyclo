import 'dart:ui';

import 'package:flame/components.dart';
import 'package:recyclo/catcher_game/common/random_generator.dart';
import 'package:recyclo/catcher_game/components.dart';
import 'package:recyclo/catcher_game/game.dart';

class DropSpawner extends Component
    with RandomGenerator, HasGameRef<CatcherGame> {
  DropSpawner({
    this.repeatNumber,
    required double floorTimeLimit,
    required double ceilingTimeLimit,
    required VoidCallback onNextSpawnCallback,
  }) : _onSpawnerUpdate = onNextSpawnCallback {
    _repeatNumberInitial = repeatNumber;
    _ceilingTimeLimit = ceilingTimeLimit;
    _floorTimeLimit = floorTimeLimit;
  }

  final VoidCallback _onSpawnerUpdate;

  // ignore: avoid_setters_without_getters
  set ceilingTimeLimit(double ceiling) => _ceilingTimeLimit = ceiling;

  // ignore: avoid_setters_without_getters
  set floorTimeLimit(double floor) => _floorTimeLimit = floor;

  bool get _isFinished => _current >= _currentLimit;
  int? repeatNumber;
  int? _repeatNumberInitial;
  late double _floorTimeLimit;
  late double _ceilingTimeLimit;
  late double _current = 0;
  late double _currentLimit = 0;
  late bool _running = false;

  @override
  void update(double dt) {
    if (game.status == CatcherGameStatusType.playing) {
      if (_running) {
        _current += dt;

        if (_isFinished) {
          if (repeatNumber != null && repeatNumber! > 0) {
            repeatNumber = -repeatNumber!;
          }

          _getCurrentLimit();
          _current -= _currentLimit;

          _onSpawnerUpdate();
        }
      }
    }
    super.update(dt);
  }

  void start() {
    _current = 0;
    repeatNumber = _repeatNumberInitial;
    _getCurrentLimit();
    _running = true;
  }

  void stop() {
    _current = 0;
    _running = false;
  }

  void _getCurrentLimit() {
    _currentLimit = doubleInRange(_floorTimeLimit, _ceilingTimeLimit);
  }
}
