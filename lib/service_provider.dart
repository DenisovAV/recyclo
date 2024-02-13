import 'package:flutter_game_challenge/artifacts/artifacts_repository.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';
import 'package:get_it/get_it.dart';

class ServiceProvider {
  static Future<void> initialize() async {
    ///Repositories
    await GetIt.instance
        .registerSingleton<TrashReserveRepository>(TrashReserveRepository())
        .initialize();

    await GetIt.instance
        .registerSingleton<ArtifactsRepository>(
          ArtifactsRepository(GetIt.instance.get()),
        )
        .initialize();

    ///Cubits
    GetIt.instance.registerFactory<TrashReserveCubit>(
      () => TrashReserveCubit(
        GetIt.instance.get(),
      ),
    );
  }

  static T get<T extends Object>() => GetIt.instance.get<T>();
}
