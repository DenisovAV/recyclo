import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitialState(_defaultDuration));

  static const int _defaultDuration = 60;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _duration = 0;

  /// additional param to timer for additional ticks
  int _penalty = 0;

  void set penalty(int ticks) {
    _penalty += ticks;
  }

  void start() {
    _duration = _defaultDuration;
    _stopwatch
      ..reset()
      ..start();
    _startTimer();
  }

  void pause() {
    _stopwatch.stop();
    _timer?.cancel();
    _safeEmit(TimerPausedState(_duration));
  }

  void resume() {
    _stopwatch.start();
    _startTimer();
  }

  void play() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }
    _startTimer();
    _tickTimer();
  }

  void restart() {
    _penalty = 0;
    _stopwatch
      ..reset()
      ..start();
    _safeEmit(TimerInitialState(_defaultDuration));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _stopwatch.stop();
    return super.close();
  }

  void _startTimer() {
    _penalty = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tickTimer());
  }

  void _tickTimer() {
    _duration = _defaultDuration - _stopwatch.elapsed.inSeconds - _penalty;
    if (_duration <= 0) {
      _timer?.cancel();
      _safeEmit(TimerFinishedState());
    } else {
      _safeEmit(TimerRunningState(_duration));
    }
  }

  void _safeEmit(TimerState state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
