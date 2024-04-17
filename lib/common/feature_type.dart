enum FeatureType {
  googleWallet(false);
  
  const FeatureType(this.isEnabled);
  
  final bool isEnabled;
}