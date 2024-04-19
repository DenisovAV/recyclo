import 'package:recyclo/app/app.dart';
import 'package:recyclo/bootstrap.dart';
import 'package:recyclo/trash_reserve/trash_reserve_repository.dart';

void main() {
  TrashReserveRepository.setDefaultReservedTrash = 999;
  
  bootstrap(() => const App());
}
