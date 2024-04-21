enum FeatureType {
  googleWallet(true);

  const FeatureType(this.isEnabled);

  final bool isEnabled;
}
