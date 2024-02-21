part of 'timer_cubit.dart';

sealed class TimerState extends Equatable {}

abstract class TimerStateWithValue extends TimerState {
  TimerStateWithValue(this.value);

  final int value;
}

class TimerInitialState extends TimerStateWithValue {
  TimerInitialState(super.value);

  @override
  List<Object> get props => [value];
}

class TimerRunningState extends TimerStateWithValue {
  TimerRunningState(super.value);

  @override
  List<Object> get props => [value];
}

class TimerPausedState extends TimerStateWithValue {
  TimerPausedState(super.value);

  @override
  List<Object?> get props => [value];
}

class TimerFinishedState extends TimerState {
  @override
  List<Object> get props => [];
}
