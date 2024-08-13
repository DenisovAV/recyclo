import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:recyclo/audio/music_service.dart';

class AppLifecycleObserver extends StatefulWidget {
  const AppLifecycleObserver({required this.child, super.key});

  final Widget child;

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    GetIt.instance.get<MusicService>().handleLifecycleStateChange(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    GetIt.instance.get<MusicService>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
