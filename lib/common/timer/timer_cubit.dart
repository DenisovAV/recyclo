import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitialState(_defaultDuration));

  static const int _defaultDuration = 60;

  int _durationInSeconds = 0;
  int _millisecondsInPause = 0;
  Timer? _timer;
  DateTime? _timeWhenPaused;

  /// additional param to timer for additional ticks
  int _penaltyInSeconds = 0;

  void decreaseTime({required int seconds}) {
    _penaltyInSeconds += seconds;
  }

  void increaseTime({required int seconds}) {
    _penaltyInSeconds -= seconds;
  }

  void start() {
    _durationInSeconds = _defaultDuration;
    _startTimer();
    _safeEmit(TimerInitialState(_defaultDuration));
  }

  void pause() {
    _timer?.cancel();
    _timeWhenPaused = DateTime.now();
    _safeEmit(TimerPausedState(_durationInSeconds));
  }

  void resume() {
    if (_timeWhenPaused != null) {
      _millisecondsInPause +=
          DateTime.now().difference(_timeWhenPaused!).inMilliseconds;
    }

    if (_millisecondsInPause >= 1000) {
      _millisecondsInPause = 0;
      _timeWhenPaused = null;
      _tickTimer();
    }

    _startTimer();
  }

  void restart() {
    _penaltyInSeconds = 0;
    _durationInSeconds = _defaultDuration;
    _safeEmit(TimerInitialState(_defaultDuration));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _startTimer() {
    _penaltyInSeconds = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tickTimer());
  }

  void _tickTimer() {
    _durationInSeconds = _durationInSeconds - 1 - _penaltyInSeconds;
    _penaltyInSeconds = 0;
    if (_durationInSeconds <= 0) {
      _timer?.cancel();
      _safeEmit(TimerFinishedState());
    } else {
      _safeEmit(TimerRunningState(_durationInSeconds));
    }
  }

  void _safeEmit(TimerState state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
