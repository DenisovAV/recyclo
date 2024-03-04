import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/service_provider.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'common/extensions/extensoins.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (ExtendedPlatform.isMobile) {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await ServiceProvider.initialize();

  Bloc.observer = AppBlocObserver();

  LicenseRegistry.addLicense(() async* {
    final poppins = await rootBundle.loadString(Assets.licenses.poppins.ofl);
    yield LicenseEntryWithLineBreaks(['poppins'], poppins);
  });

  // Add cross-flavor configuration here
  runApp(await builder());
}
