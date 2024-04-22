enum FeatureType {
  googleWallet(isEnabled: true);

  const FeatureType({
    required this.isEnabled,
  });

  final bool isEnabled;
}
