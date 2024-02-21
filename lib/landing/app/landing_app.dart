import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/index.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
