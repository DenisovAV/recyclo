import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game_challenge/audio/music_service.dart';
import 'package:flutter_game_challenge/audio/sounds.dart';
import 'package:flutter_game_challenge/finder_game/events/event_type.dart';
import 'package:flutter_game_challenge/finder_game/events/finder_game_event.dart';
import 'package:flutter_game_challenge/finder_game/finder_game.dart';
import 'package:get_it/get_it.dart';

class FinderSoundPlayer extends Component with HasGameRef<FinderGame> {
  MusicService get musicService => GetIt.instance.get<MusicService>();

  late StreamSubscription<FinderGameEvent> _subscription;

  @override
  Future<void> onLoad() async {
    _subscription = game.eventStream.listen(eventReceived);
  }

  @override
  void onRemove() {
    _subscription.cancel();
    super.onRemove();
  }

  void eventReceived(FinderGameEvent gameEvent) {
    switch (gameEvent.type) {
      case EventType.wrongItem:
        //musicService.playSound(Sounds.artifactCrafted);
        break;
      case EventType.correctItem:
        break;
      case EventType.itemCollected:
        musicService.playSound(Sounds.artifactCrafted);
        break;
      case EventType.dragStarted:
        // TODO: Handle this case.
        break;
      case EventType.dragEnded:
        // TODO: Handle this case.
        break;
    }
  }
}
