import 'package:audioplayers/audioplayers.dart';
import 'package:flame/flame.dart';
import 'package:get_it/get_it.dart';
import 'package:recyclo/app/app_localisations_provider.dart';
import 'package:recyclo/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:recyclo/artifacts/artifacts_repository.dart';
import 'package:recyclo/artifacts/cubit/artifacts_cubit.dart';
import 'package:recyclo/artifacts/wallet/service/mobile_wallet_service.dart'
    if (dart.library.html) 'package:recyclo/artifacts/wallet/service/web_wallet_service.dart';
import 'package:recyclo/artifacts/wallet/service/wallet_interface.dart';
import 'package:recyclo/audio/music_service.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/menu/cubit/main_page_cubit.dart';
import 'package:recyclo/settings/cubit/settings_cubit.dart';
import 'package:recyclo/settings/persistence/local_storage_settings_persistence.dart';
import 'package:recyclo/settings/persistence/settings_persistence.dart';
import 'package:recyclo/settings/settings.dart';
import 'package:recyclo/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:recyclo/trash_reserve/trash_reserve_repository.dart';

class ServiceProvider {
  static Future<void> initialize() async {
    final getIt = GetIt.instance;

    //Services
    // ignore: cascade_invocations
    getIt
      ..registerFactory<WalletService>(
        getWalletService,
      )
      ..registerLazySingleton<MusicService>(
        () => MusicService(
          GetIt.instance.get(),
          GetIt.instance.get(),
        ),
      )
      ..registerLazySingleton<AppLocalizationsProvider>(
        () => AppLocalizationsProvider(
          GetIt.instance.get(),
        ),
      );

    await getIt
        .registerSingleton<SettingsPersistence>(
          LocalStorageSettingsPersistence(),
        )
        .initialize();

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
          getIt.get(),
        ),
      )
      ..registerFactory<TimerCubit>(
        TimerCubit.new,
      )
      ..registerFactory<TutorialCubit>(
        () => TutorialCubit(
          localDataRepository: getIt.get(),
        ),
      )
      ..registerFactory<MainPageCubit>(
        () => MainPageCubit(
          GetIt.instance.get(),
        ),
      )
      ..registerFactory<SettingsCubit>(
        () => SettingsCubit(
          GetIt.instance.get(),
          GetIt.instance.get(),
          GetIt.instance.get(),
        ),
      )

      ///Game Resources
      ..registerSingleton<AssetsLoader>(
        AssetsLoader(images: Flame.images..prefix = ''),
      )

      ///Cross cutting
      ..registerLazySingleton<SettingsController>(
        () => SettingsController(
          getIt.get(),
        ),
      )
      ..registerLazySingleton<CreatePlayerFunction>(() => AudioPlayer.new);
  }

  static T get<T extends Object>() => GetIt.instance.get<T>();
}

typedef CreatePlayerFunction = AudioPlayer Function();
