import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_repository.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_cubit.dart';
import 'package:flutter_game_challenge/artifacts/wallet/service/mobile_wallet_service.dart'
    if (dart.library.html) 'package:flutter_game_challenge/artifacts/wallet/service/web_wallet_service.dart';
import 'package:flutter_game_challenge/artifacts/wallet/service/wallet_interface.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';
import 'package:get_it/get_it.dart';

class ServiceProvider {
  static Future<void> initialize() async {
    final getIt = GetIt.instance;

    //Services
    getIt.registerFactory<WalletService>(
      getWalletService,
    );

    ///Repositories
    await getIt
        .registerSingleton<TrashReserveRepository>(TrashReserveRepository())
        .initialize();

    await getIt
        .registerSingleton<ArtifactsRepository>(
          ArtifactsRepository(getIt.get()),
        )
        .initialize();

    await getIt
        .registerSingleton<LocalDataRepository>(
          LocalDataRepository(),
        )
        .initialize();

    ///Cubits
    getIt
      ..registerFactory<TrashReserveCubit>(
        () => TrashReserveCubit(
          getIt.get(),
        ),
      )
      ..registerFactory<ArtifactsCubit>(
        () => ArtifactsCubit(
          getIt.get(),
        ),
      )
      ..registerFactory<ArtifactDetailsCubit>(
        () => ArtifactDetailsCubit(
          getIt.get(),
          getIt.get(),
          getIt.get(),
        ),
      )
      ..registerFactory<TimerCubit>(
        TimerCubit.new,
      )
      ..registerFactory<TutorialCubit>(() => TutorialCubit(
            localDataRepository: getIt.get(),
          ));
  }

  static T get<T extends Object>() => GetIt.instance.get<T>();
}
