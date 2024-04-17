import 'package:flutter/material.dart';
import 'package:recyclo/app/view/app.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/index.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LandingApp());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
