import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/app/app_localisations_provider.dart';
import 'package:flutter_game_challenge/app_lifecycle/app_lifecycle.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/loading/loading.dart';
import 'package:flutter_game_challenge/service_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final kNestedNavigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AppLifecycleObserver(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => PreloadCubit(
              Images(prefix: ''),
            )..loadSequentially(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLocalizationsProvider>(
      create: (_) => ServiceProvider.get<AppLocalizationsProvider>()..getLocale(),
      child: Consumer<AppLocalizationsProvider>(
        builder: (context, provider, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: FlutterGameChallengeColors.primary1,
            appBarTheme: const AppBarTheme(
              color: FlutterGameChallengeColors.primary1,
            ),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: FlutterGameChallengeColors.primary1,
            ),
            scaffoldBackgroundColor: FlutterGameChallengeColors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  FlutterGameChallengeColors.primary1,
                ),
              ),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          locale: provider.currentLanguage.locale,
          localizationsDelegates:  provider.localizationsDelegates,
          supportedLocales: provider.supportLocales,
          home: const LoadingPage(),
        ),
      ),
    );
  }
}
