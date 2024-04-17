extension AssetSourceExtension on String {
  String toAssetSource() => replaceFirst('assets/', '');
}
