import 'package:flame/flame.dart';
import 'package:recyclo/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:recyclo/artifacts/artifacts_repository.dart';
import 'package:recyclo/artifacts/cubit/artifacts_cubit.dart';
import 'package:recyclo/artifacts/wallet/service/mobile_wallet_service.dart'
    if (dart.library.html) 'package:recyclo/artifacts/wallet/service/web_wallet_service.dart';
import 'package:recyclo/artifacts/wallet/service/wallet_interface.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:recyclo/trash_reserve/trash_reserve_repository.dart';
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

    ///Game Resources
    getIt.registerSingleton<AssetsLoader>(
      AssetsLoader(images: Flame.images..prefix = ''),
    );
  }

  static T get<T extends Object>() => GetIt.instance.get<T>();
}
