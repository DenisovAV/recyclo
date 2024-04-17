import 'dart:core';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:recyclo/artifacts/artifacts_model.dart';
import 'package:recyclo/artifacts/wallet/service/artifacts_wallet.dart';
import 'package:recyclo/artifacts/wallet/service/wallet_interface.dart';

WalletService getWalletService() {
  if (Platform.isAndroid) {
    return AndroidWalletService();
  } else {
    return IosWalletService();
  }
}

class IosWalletService implements WalletService {
  Future<void> addToWallet(ArtifactType artifactType, String uid) async {
    throw UnimplementedError();
  }

  Future<void> viewInWallet(String uid) async {
    throw UnimplementedError();
  }
}

class AndroidWalletService implements WalletService {
  static const method = MethodChannel('REQUEST_WALLET');

  Future<void> addToWallet(ArtifactType artifactType, String uid) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'generateWalletObjectJWT',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      final artifact = wallet[artifactType]!;

      final HttpsCallableResult result = await callable.call({
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
      print("Failed to add to walletr: '${e}'.");
    }
  }

  Future<void> viewInWallet(String uid) async {
    try {
      await method.invokeMethod('VIEW_IN_WALLET', {'id': uid});
    } on Exception catch (e) {
      print("Failed to open wallet: '${e}'.");
    }
  }
}
