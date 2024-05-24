import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:recyclo/common/extensions.dart';
import 'package:recyclo/menu/cubit/main_page_cubit.dart';
import 'package:recyclo/menu/view/main_menu_page_mobile.dart';
import 'package:recyclo/menu/view/main_menu_page_tv.dart';
import 'package:recyclo/service_provider.dart';
import 'package:recyclo/trash_reserve/cubit/trash_reserve_cubit.dart';

class MainMenuPage {
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<MainPageCubit>(create: (_) => GetIt.instance.get()),
          BlocProvider<TrashReserveCubit>(create: (_) => ServiceProvider.get()),
        ],
        child: ExtendedPlatform.isTv
            ? const MainMenuPageTv()
            : const MainMenuPageMobile(),
      ),
    );
  }
}
