import 'package:flutter_game_challenge/app/app.dart';
import 'package:flutter_game_challenge/bootstrap.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';

void main() {
  TrashReserveRepository.setDefaultReservedTrash = 999;
  
  bootstrap(() => const App());
}
