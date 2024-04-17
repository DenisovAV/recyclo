import 'package:recyclo/artifacts/artifacts_model.dart';

abstract class WalletService {
  Future<void> addToWallet(ArtifactType artifact, String id);
  Future<void> viewInWallet(String id);
}
