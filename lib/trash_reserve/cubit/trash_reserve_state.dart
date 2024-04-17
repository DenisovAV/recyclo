import 'package:recyclo/trash_reserve/trash_reserve_repository.dart';

class TrashReserveState {
  TrashReserveState({required this.model});

  TrashReserveState.empty() : model = const TrashReserveModel.empty();

  final TrashReserveModel model;
}
