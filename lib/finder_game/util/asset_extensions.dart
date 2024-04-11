extension AssetExtensions on String {
  String trimAssetPath() {
    return this.replaceFirst(
      'assets/images/',
      '',
    );
  }
}
