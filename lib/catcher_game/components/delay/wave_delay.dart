import 'dart:ui';

import 'package:flame/components.dart';
import 'package:recyclo/catcher_game/game.dart';
import 'package:recyclo/catcher_game/main_scene.dart';

class WaveDelay extends Component with HasGameRef<CatcherGame> {
  WaveDelay({
    required this.scene,
    required this.duration,
    required void Function() onWaveFinished,
  }) : _onWaveFinished = onWaveFinished;

  final MainScene scene;

  CatcherGameStatus get status => game.status;

  double get current => _current;

  double get progress => _current / duration;

  double _current = 0;
  double duration = 0;
  bool _running = false;

  final VoidCallback _onWaveFinished;

  @override
  void update(double dt) {
    if (status == CatcherGameStatus.playing) {
      if (_running) {
        _current += dt;

        if (isFinished()) {
          _running = false;
          _onWaveFinished();
        }
      }
    }
  }

  bool isFinished() => _current >= duration;

  bool isRunning() => _running;

  void start() {
    _current = 0;
    _running = true;
  }

  void stop() {
    _current = 0;
    _running = false;
  }

  void reset(double duration) {
    _current = 0;
    _running = true;
  }
}
