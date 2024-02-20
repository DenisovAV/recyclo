/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// File path: assets/audio/background.mp3
  String get background => 'assets/audio/background.mp3';

  /// File path: assets/audio/effect.mp3
  String get effect => 'assets/audio/effect.mp3';

  /// List of all assets
  List<String> get values => [background, effect];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/add_to_wallet.png
  AssetGenImage get addToWallet =>
      const AssetGenImage('assets/images/add_to_wallet.png');

  /// File path: assets/images/artifact_car.png
  AssetGenImage get artifactCar =>
      const AssetGenImage('assets/images/artifact_car.png');

  /// File path: assets/images/artifact_house.png
  AssetGenImage get artifactHouse =>
      const AssetGenImage('assets/images/artifact_house.png');

  /// File path: assets/images/artifact_laptop.png
  AssetGenImage get artifactLaptop =>
      const AssetGenImage('assets/images/artifact_laptop.png');

  /// File path: assets/images/artifact_newspaper.png
  AssetGenImage get artifactNewspaper =>
      const AssetGenImage('assets/images/artifact_newspaper.png');

  /// File path: assets/images/artifact_plant.png
  AssetGenImage get artifactPlant =>
      const AssetGenImage('assets/images/artifact_plant.png');

  /// File path: assets/images/artifact_shampoo.png
  AssetGenImage get artifactShampoo =>
      const AssetGenImage('assets/images/artifact_shampoo.png');

  /// File path: assets/images/clouds.png
  AssetGenImage get clouds => const AssetGenImage('assets/images/clouds.png');

  /// File path: assets/images/earth.png
  AssetGenImage get earth => const AssetGenImage('assets/images/earth.png');

  /// File path: assets/images/energy.png
  AssetGenImage get energy => const AssetGenImage('assets/images/energy.png');

  /// File path: assets/images/game_mode_cathcer.png
  AssetGenImage get gameModeCathcer =>
      const AssetGenImage('assets/images/game_mode_cathcer.png');

  /// File path: assets/images/game_mode_clicker.png
  AssetGenImage get gameModeClicker =>
      const AssetGenImage('assets/images/game_mode_clicker.png');

  /// File path: assets/images/game_mode_finder.png
  AssetGenImage get gameModeFinder =>
      const AssetGenImage('assets/images/game_mode_finder.png');

  /// File path: assets/images/glass.png
  AssetGenImage get glass => const AssetGenImage('assets/images/glass.png');

  /// File path: assets/images/icon_forbidden.png
  AssetGenImage get iconForbidden =>
      const AssetGenImage('assets/images/icon_forbidden.png');

  /// File path: assets/images/icon_geer.png
  AssetGenImage get iconGeer =>
      const AssetGenImage('assets/images/icon_geer.png');

  /// File path: assets/images/icon_ok.png
  AssetGenImage get iconOk => const AssetGenImage('assets/images/icon_ok.png');

  /// File path: assets/images/icon_wallet.png
  AssetGenImage get iconWallet =>
      const AssetGenImage('assets/images/icon_wallet.png');

  /// File path: assets/images/organic.png
  AssetGenImage get organic => const AssetGenImage('assets/images/organic.png');

  /// File path: assets/images/paper.png
  AssetGenImage get paper => const AssetGenImage('assets/images/paper.png');

  /// File path: assets/images/plastic.png
  AssetGenImage get plastic => const AssetGenImage('assets/images/plastic.png');

  /// File path: assets/images/unicorn_animation.png
  AssetGenImage get unicornAnimation => const AssetGenImage('assets/images/unicorn_animation.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        addToWallet,
        artifactCar,
        artifactHouse,
        artifactLaptop,
        artifactNewspaper,
        artifactPlant,
        artifactShampoo,
        clouds,
        earth,
        energy,
        gameModeCathcer,
        gameModeClicker,
        gameModeFinder,
        glass,
        iconForbidden,
        iconGeer,
        iconOk,
        iconWallet,
        organic,
        paper,
        plastic,
        unicornAnimation
      ];
}

class $AssetsLicensesGen {
  const $AssetsLicensesGen();

  $AssetsLicensesPoppinsGen get poppins => const $AssetsLicensesPoppinsGen();
}

class $AssetsLicensesPoppinsGen {
  const $AssetsLicensesPoppinsGen();

  /// File path: assets/licenses/poppins/OFL.txt
  String get ofl => 'assets/licenses/poppins/OFL.txt';

  /// List of all assets
  List<String> get values => [ofl];
}

class Assets {
  Assets._();

  static const $AssetsAudioGen audio = $AssetsAudioGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLicensesGen licenses = $AssetsLicensesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
