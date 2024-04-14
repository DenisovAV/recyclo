import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/audio/music_service.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

typedef AppLifecycleStateNotifier = ValueNotifier<AppLifecycleState>;

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  const AppLifecycleObserver({required this.child, super.key});

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver> {
  late final AppLifecycleListener _appLifecycleListener;

  final ValueNotifier<AppLifecycleState> lifecycleListenable =
      ValueNotifier(AppLifecycleState.inactive);

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<AppLifecycleStateNotifier>.value(
      value: lifecycleListenable,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    GetIt.instance.get<MusicService>().dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _appLifecycleListener = AppLifecycleListener(
      onStateChange: (appState) => lifecycleListenable.value = appState,
    );

    GetIt.instance.get<MusicService>().lifecycleNotifier = lifecycleListenable;
  }
}
