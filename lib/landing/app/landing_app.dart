import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recyclo/app/app_localisations_provider.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/index.dart';
import 'package:recyclo/service_provider.dart';

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LandingApp());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLocalizationsProvider>(
      create: (BuildContext context) =>
          ServiceProvider.get<AppLocalizationsProvider>()..getLocale(),
      child: MaterialApp(
        // navigatorKey: kRootNavigatorKey,
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
          textTheme: GoogleFonts.snigletTextTheme(),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MainPage(),
      ),
    );
  }
}
