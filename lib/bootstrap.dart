import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:recyclo/common/assets/assets.gen.dart';
import 'package:recyclo/common/extensions.dart';
import 'package:recyclo/framework/remote_controller.dart';
import 'package:recyclo/service_provider.dart';

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

  if (!kIsWeb) {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await ServiceProvider.initialize();
  await ExtendedPlatform.initialize();

  if (ExtendedPlatform.isAppleTv) {
    RemoteController().init();
  }

  Bloc.observer = AppBlocObserver();

  LicenseRegistry.addLicense(() async* {
    final poppins = await rootBundle.loadString(Assets.licenses.poppins.ofl);
    yield LicenseEntryWithLineBreaks(['poppins'], poppins);
  });

  // Add cross-flavor configuration here
  runApp(await builder());
}
