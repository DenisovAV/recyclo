import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_game_challenge/audio/extensions.dart';
import 'package:flutter_game_challenge/common/assets/assets.gen.dart';

class Songs {
  static AssetSource mainMenuAmbient =
      AssetSource(Assets.audio.mainMenuTheme.toAssetSource());
  static AssetSource clickerTheme =
      AssetSource(Assets.audio.clickerTheme.toAssetSource());
  static AssetSource catcherTheme =
      AssetSource(Assets.audio.catcherTheme.toAssetSource());
  static AssetSource finderTheme =
      AssetSource(Assets.audio.finderTheme.toAssetSource());
}
