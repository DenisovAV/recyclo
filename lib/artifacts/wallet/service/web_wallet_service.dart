import 'dart:core';
import 'package:recyclo/artifacts/artifacts_model.dart';
import 'package:recyclo/artifacts/wallet/service/wallet_interface.dart';

WalletService getWalletService() {
  return WebWalletService();
}

class WebWalletService implements WalletService {
  @override
  Future<void> addToWallet(ArtifactType artifactType, String uid) async {
    throw UnimplementedError();
  }

  @override
  Future<void> viewInWallet(String uid) async {
    throw UnimplementedError();
  }
}
