import 'dart:ui';

import 'package:flame/components.dart';
import 'package:recyclo/catcher_game/common/random_generator.dart';
import 'package:recyclo/catcher_game/game.dart';

class DropSpawner extends Component
    with RandomGenerator, HasGameRef<CatcherGame> {
  DropSpawner({
    required int repeatNumber,
    required double floorTimeLimit,
    required double ceilingTimeLimit,
    required VoidCallback onSpawnerUpdate,
  }) : _onSpawnerUpdate = onSpawnerUpdate {
    _repeatNumberInitial = repeatNumber - 1;
    _ceilingTimeLimit = ceilingTimeLimit;
    _floorTimeLimit = floorTimeLimit;
    _repeatNumber = _repeatNumberInitial;
  }

  CatcherGameStatus get status => game.status;

  double get current => _current;

  double get progress => _current / _currentLimit;

  set repeatNumber(int n) => _repeatNumberInitial = n - 1;

  int get repeatNumber => _repeatNumber;

  // ignore: avoid_setters_without_getters
  set ceilingTimeLimit(double ceiling) => _ceilingTimeLimit = ceiling;

  // ignore: avoid_setters_without_getters
  set floorTimeLimit(double floor) => _floorTimeLimit = floor;

  late int _repeatNumber;
  late int _repeatNumberInitial;
  late double _floorTimeLimit;
  late double _ceilingTimeLimit;
  late double _current = 0;
  late double _currentLimit = 0;
  late bool _running = false;

  final VoidCallback _onSpawnerUpdate;

  @override
  void update(double dt) {
    if (status == CatcherGameStatus.playing) {
      if (_running) {
        _current += dt;

        if (isFinished()) {
          if (_repeatNumber > 0) {
            _getCurrentLimit();
            _current -= _currentLimit;
            --_repeatNumber;
          } else {
            _running = false;
          }

          _onSpawnerUpdate();
        }
      }
    }
    super.update(dt);
  }

  bool isFinished() => _current >= _currentLimit;

  bool isRunning() => _running;

  void start() {
    _current = 0;
    _repeatNumber = _repeatNumberInitial;
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
