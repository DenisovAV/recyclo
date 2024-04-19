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
}
