import 'dart:core';
import 'dart:developer';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:recyclo/artifacts/artifacts_model.dart';
import 'package:recyclo/artifacts/wallet/service/artifacts_wallet.dart';
import 'package:recyclo/artifacts/wallet/service/wallet_interface.dart';
import 'package:recyclo/common.dart';

const method = MethodChannel('REQUEST_WALLET');

WalletService getWalletService() {
  if (ExtendedPlatform.isAndroid) {
    return AndroidWalletService();
  } else if (ExtendedPlatform.isApple) {
    return IosWalletService();
  } else {
    throw Exception('This platform is not supported yet');
  }
}

class IosWalletService implements WalletService {
  @override
  Future<void> addToWallet(ArtifactType artifactType, String uid) async {
    try {
      final artifact = appleWallet[artifactType]!;
      await method.invokeMethod('ADD_TO_WALLET', {'passUrl': artifact});
    } on Exception catch (e) {
      log("Failed to add to wallet: '$e'.");
    }
  }

  @override
  Future<void> viewInWallet(String uid) async {
    try {
      await method.invokeMethod('VIEW_IN_WALLET', {'id': uid});
    } on Exception catch (e) {
      log("Failed to open wallet: '$e'.");
    }
  }
}

class AndroidWalletService implements WalletService {
  @override
  Future<void> addToWallet(ArtifactType artifactType, String uid) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'generateWalletObjectJWT',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      final artifact = androidWallet[artifactType]!;

      final result = await callable.call<Map<String, String>>({
        'objectSuffix': uid,
        'title': artifact.title,
        'header': artifact.header,
        'details': artifact.details,
        'description': artifact.description,
        'reality': artifact.reality,
        'image': artifact.image,
        'imageText': artifact.imageText,
        'heroImage': artifact.heroImage,
        'backgroundColor': artifact.backgroundColor,
      });
      final jwt = result.data['jwt'];

      await method.invokeMethod('ADD_TO_WALLET', {'jwt': jwt});
    } on Exception catch (e) {
      log("Failed to add to wallet: '$e'.");
    }
  }

  @override
  Future<void> viewInWallet(String uid) async {
    try {
      await method.invokeMethod('VIEW_IN_WALLET', {'id': uid});
    } on Exception catch (e) {
      log("Failed to open wallet: '$e'.");
    }
  }
}
