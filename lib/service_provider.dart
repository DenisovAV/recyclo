import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_repository.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_cubit.dart';
import 'package:flutter_game_challenge/artifacts/wallet/service/wallet_interface.dart';
import 'package:flutter_game_challenge/audio/music_service.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_cubit.dart';
import 'package:flutter_game_challenge/settings/cubit/settings_cubit.dart';
import 'package:flutter_game_challenge/settings/settings.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_game_challenge/artifacts/wallet/service/mobile_wallet_service.dart'
    if (dart.library.html) 'package:flutter_game_challenge/artifacts/wallet/service/web_wallet_service.dart';

class ServiceProvider {
  static Future<void> initialize() async {
    //Services
    GetIt.I.registerFactory<WalletService>(
      getWalletService,
    );

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

    GetIt.instance.registerFactory<MainPageCubit>(
      () => MainPageCubit(
        GetIt.instance.get(),
      ),
    );

    GetIt.instance.registerFactory<ArtifactsCubit>(
      () => ArtifactsCubit(
        GetIt.instance.get(),
      ),
    );

    GetIt.instance.registerFactory<SettingsCubit>(
      () => SettingsCubit(
        GetIt.instance.get(),
        GetIt.instance.get(),
      ),
    );

    GetIt.instance.registerFactory<ArtifactDetailsCubit>(
      () => ArtifactDetailsCubit(
        GetIt.instance.get(),
        GetIt.instance.get(),
        GetIt.instance.get(),
        GetIt.instance.get(),
      ),
    );

    GetIt.instance.registerFactory<TimerCubit>(
      TimerCubit.new,
    );

    GetIt.instance
        .registerLazySingleton<SettingsController>(SettingsController.new);

    GetIt.instance.registerLazySingleton<MusicService>(
      () => MusicService(
        GetIt.instance.get(),
      ),
    );
  }

  static T get<T extends Object>() => GetIt.instance.get<T>();
}
