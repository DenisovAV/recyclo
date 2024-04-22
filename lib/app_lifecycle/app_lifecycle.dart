import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:recyclo/audio/music_service.dart';

typedef AppLifecycleStateNotifier = ValueNotifier<AppLifecycleState>;

class AppLifecycleObserver extends StatefulWidget {

  const AppLifecycleObserver({required this.child, super.key});
  final Widget child;

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver> {
  late final AppLifecycleListener _appLifecycleListener;

  final ValueNotifier<AppLifecycleState> lifecycleListenable =
      ValueNotifier(AppLifecycleState.inactive);

  @override
  void initState() {
    super.initState();
    _appLifecycleListener = AppLifecycleListener(
      onStateChange: (appState) => lifecycleListenable.value = appState,
    );

    GetIt.instance.get<MusicService>().lifecycleNotifier = lifecycleListenable;
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    GetIt.instance.get<MusicService>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<AppLifecycleStateNotifier>.value(
      value: lifecycleListenable,
      child: widget.child,
    );
  }
}
