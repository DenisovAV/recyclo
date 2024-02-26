import 'dart:async';

import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/requirements.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtifactsRepository {
  ArtifactsRepository(this._trashReserveRepository);

  late final SharedPreferences _sharedPreferences;
  late ArtifactsModel _artifactsModel;

  final TrashReserveRepository _trashReserveRepository;
  final StreamController<ArtifactsModel> _streamController =
      StreamController.broadcast();

  ArtifactsModel get artifactModel => _artifactsModel;
  Stream<ArtifactsModel> get artifactModelStream => _streamController.stream;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _artifactsModel = ArtifactsModel(
      newspaper: _getArtifact(
        requirements: Requirements.newspaper,
        isCraftedKey: _ArtifactStatusKeys.newspaperIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.newspaperInWallet,
        artifactType: ArtifactType.newspaper,
      ),
      shampoo: _getArtifact(
        requirements: Requirements.shampoo,
        isCraftedKey: _ArtifactStatusKeys.shampooIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.shampooInWallet,
        artifactType: ArtifactType.shampoo,
      ),
      plant: _getArtifact(
        requirements: Requirements.plant,
        isCraftedKey: _ArtifactStatusKeys.plantIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.plantInWallet,
        artifactType: ArtifactType.plant,
      ),
      laptop: _getArtifact(
        requirements: Requirements.laptop,
        isCraftedKey: _ArtifactStatusKeys.laptopIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.laptopInWallet,
        artifactType: ArtifactType.laptop,
      ),
      car: _getArtifact(
        requirements: Requirements.car,
        isCraftedKey: _ArtifactStatusKeys.carIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.carInWallet,
        artifactType: ArtifactType.car,
      ),
      house: _getArtifact(
        requirements: Requirements.house,
        isCraftedKey: _ArtifactStatusKeys.houseIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.houseInWallet,
        artifactType: ArtifactType.house,
      ),
    );

    _streamController.add(artifactModel);
  }

  ArtifactModel _getArtifact({
    required ArtifactRequirements requirements,
    required ArtifactType artifactType,
    required String isCraftedKey,
    required String isInWalletKey,
  }) {
    return ArtifactModel(
      requirements: requirements,
      artifactType: artifactType,
      status: _getArtifactStatus(
        isCraftedKey: isCraftedKey,
        isInWalletKey: isInWalletKey,
        requirements: requirements,
      ),
    );
  }

  ArtifactStatus _getArtifactStatus({
    required String isCraftedKey,
    required String isInWalletKey,
    required ArtifactRequirements requirements,
  }) {
    if (_sharedPreferences.getBool(isInWalletKey) ?? false) {
      return ArtifactStatus.addedToWallet;
    }

    if (_sharedPreferences.getBool(isCraftedKey) ?? false) {
      return ArtifactStatus.crafted;
    }

    if (_isEnoughResources(requirements)) {
      return ArtifactStatus.readyForCraft;
    }

    return ArtifactStatus.notEnoughResources;
  }

  bool _isEnoughResources(ArtifactRequirements requirements) {
    final reservedTrash = _trashReserveRepository.reservedTrash;

    return reservedTrash.electronics >= requirements.electronics &&
        reservedTrash.glass >= requirements.glass &&
        reservedTrash.organic >= requirements.organic &&
        reservedTrash.paper >= requirements.paper &&
        reservedTrash.plastic >= requirements.plastic;
  }

  ArtifactModel craftArtifact(ArtifactModel artifact) {
    if (!_isEnoughResources(artifact.requirements) || artifact.isCrafted) {
      return artifact;
    }

    _trashReserveRepository.removeResources(
      plastic: artifact.requirements.plastic,
      organic: artifact.requirements.organic,
      glass: artifact.requirements.glass,
      paper: artifact.requirements.paper,
      electronics: artifact.requirements.electronics,
    );

    final newArtifact = artifact.copyWithStatus(ArtifactStatus.crafted);

    switch (artifact.artifactType) {
      case ArtifactType.newspaper:
        _artifactsModel = _artifactsModel.copyWith(newspaper: newArtifact);
        _sharedPreferences.setBool(
          _ArtifactStatusKeys.newspaperIsCrafted,
          true,
        );
      case ArtifactType.shampoo:
        _artifactsModel = _artifactsModel.copyWith(shampoo: newArtifact);
        _sharedPreferences.setBool(
          _ArtifactStatusKeys.shampooIsCrafted,
          true,
        );
      case ArtifactType.plant:
        _artifactsModel = _artifactsModel.copyWith(plant: newArtifact);
        _sharedPreferences.setBool(
          _ArtifactStatusKeys.plantIsCrafted,
          true,
        );
      case ArtifactType.laptop:
        _artifactsModel = _artifactsModel.copyWith(laptop: newArtifact);
        _sharedPreferences.setBool(
          _ArtifactStatusKeys.laptopIsCrafted,
          true,
        );
      case ArtifactType.car:
        _artifactsModel = _artifactsModel.copyWith(car: newArtifact);
        _sharedPreferences.setBool(
          _ArtifactStatusKeys.carIsCrafted,
          true,
        );
      case ArtifactType.house:
        _artifactsModel = _artifactsModel.copyWith(house: newArtifact);
        _sharedPreferences.setBool(
          _ArtifactStatusKeys.houseIsCrafted,
          true,
        );
    }
    _streamController.add(artifactModel);
    _artifactsModel = artifactModel;
    return newArtifact;
  }
}

class _ArtifactStatusKeys {
  static const shampooInWallet = 'artifactsRepositoryStatusShampooInWallet';
  static const shampooIsCrafted = 'artifactsRepositoryStatusShampooIsCrafted';

  static const carInWallet = 'artifactsRepositoryStatusCarInWallet';
  static const carIsCrafted = 'artifactsRepositoryStatusCarIsCrafted';

  static const plantInWallet = 'artifactsRepositoryStatusPlantInWallet';
  static const plantIsCrafted = 'artifactsRepositoryStatusPlantIsCrafted';

  static const laptopInWallet = 'artifactsRepositoryStatusLaptopInWallet';
  static const laptopIsCrafted = 'artifactsRepositoryStatusLaptopIsCrafted';

  static const houseInWallet = 'artifactsRepositoryStatusHouseInWallet';
  static const houseIsCrafted = 'artifactsRepositoryStatusHouseIsCrafted';

  static const newspaperInWallet = 'artifactsRepositoryStatusNewsPaperInWallet';
  static const newspaperIsCrafted =
      'artifactsRepositoryStatusNewsPaperIsCrafted';
}
