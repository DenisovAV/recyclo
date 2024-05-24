import 'dart:async';

import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';
import 'package:recyclo/audio/music_service.dart';
import 'package:recyclo/audio/sounds.dart';
import 'package:recyclo/finder_game/events/event_type.dart';
import 'package:recyclo/finder_game/events/finder_game_event.dart';
import 'package:recyclo/finder_game/finder_game.dart';

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
        musicService.playSound(Sounds.incorrectItem);
        break;
      case EventType.correctItem:
        musicService.playSound(Sounds.correctItem);
        break;
      case EventType.itemCollected:
        musicService.playSound(Sounds.pickup);
        break;
      case EventType.dragStarted:
      case EventType.dragEnded:
        musicService.playSound(Sounds.bushRustle);
        break;
      case EventType.gameEnd:
        musicService.playSound(Sounds.timeIsUp);
        break;
    }
  }
}
