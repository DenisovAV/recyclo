import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/trash_reserve/cubit/trash_reserve_state.dart';
import 'package:recyclo/trash_reserve/trash_reserve_repository.dart';

class TrashReserveCubit extends Cubit<TrashReserveState> {
  TrashReserveCubit(this._trashReserveRepository)
      : super(TrashReserveState.empty()) {
    initialize();
  }

  final TrashReserveRepository _trashReserveRepository;

  StreamSubscription<TrashReserveModel>? _trashReserveSubscription;

  Future<void> initialize() async {
    emit(TrashReserveState(model: _trashReserveRepository.reservedTrash));
    
    _trashReserveSubscription =
        _trashReserveRepository.reservedTrashStream.listen((newValue) {
      emit(TrashReserveState(model: newValue));
    });
  }

  @override
  Future<void> close() {
    _trashReserveSubscription?.cancel();
    return super.close();
  }
}
