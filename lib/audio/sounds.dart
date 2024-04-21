import 'package:audioplayers/audioplayers.dart';
import 'package:recyclo/audio/extensions.dart';
import 'package:recyclo/common.dart';

class Sounds {
  static AssetSource buttonTap =
      AssetSource(Assets.audio.buttonTap.toAssetSource());
  static AssetSource artifactCrafted =
      AssetSource(Assets.audio.artifactCrafted.toAssetSource());
  static AssetSource toggleSound =
      AssetSource(Assets.audio.toggleSound.toAssetSource());
  static AssetSource correctItem =
      AssetSource(Assets.audio.correctItem.toAssetSource());
  static AssetSource incorrectItem =
      AssetSource(Assets.audio.incorrectItem.toAssetSource());
  static AssetSource bushRustle =
      AssetSource(Assets.audio.bushRustle.toAssetSource());
  static AssetSource pickup =
      AssetSource(Assets.audio.itemPickupSound.toAssetSource());
  static AssetSource timeIsUp =
      AssetSource(Assets.audio.timeIsUp.toAssetSource());
}
