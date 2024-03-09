import 'dart:async';

import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/requirements.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ArtifactsRepository {
  ArtifactsRepository(this._trashReserveRepository);

  late final SharedPreferences _sharedPreferences;
  late ArtifactsModel _artifactsModel;

  final TrashReserveRepository _trashReserveRepository;
  final StreamController<ArtifactsModel> _streamController =
      StreamController.broadcast();

  final Uuid _uuid = Uuid();

  ArtifactsModel get artifactModel {
    _updateArtifactStatuses();
    return _artifactsModel;
  }

  Stream<ArtifactsModel> get artifactModelStream => _streamController.stream;

  void _updateArtifactStatuses() {
    _artifactsModel = _artifactsModel.copyWith(
      newspaper: _artifactsModel.newspaper.copyWith(
        status: _getUpdatedArtifactStatus(_artifactsModel.newspaper),
      ),
      shampoo: _artifactsModel.shampoo.copyWith(
        status: _getUpdatedArtifactStatus(_artifactsModel.shampoo),
      ),
      plant: _artifactsModel.plant.copyWith(
        status: _getUpdatedArtifactStatus(_artifactsModel.plant),
      ),
      laptop: _artifactsModel.laptop.copyWith(
        status: _getUpdatedArtifactStatus(_artifactsModel.laptop),
      ),
      car: _artifactsModel.car.copyWith(
        status: _getUpdatedArtifactStatus(_artifactsModel.car),
      ),
      house: _artifactsModel.house.copyWith(
        status: _getUpdatedArtifactStatus(_artifactsModel.house),
      ),
    );
  }

  ArtifactStatus _getUpdatedArtifactStatus(ArtifactModel model) {
    if (model.status == ArtifactStatus.notEnoughResources &&
        _isEnoughResources(model.requirements)) {
      return ArtifactStatus.readyForCraft;
    }

    if (model.status == ArtifactStatus.readyForCraft &&
        !_isEnoughResources(model.requirements)) {
      return ArtifactStatus.notEnoughResources;
    }

    return model.status;
  }

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _artifactsModel = ArtifactsModel(
      newspaper: _getArtifact(
        requirements: Requirements.newspaper,
        isCraftedKey: _ArtifactStatusKeys.newspaperIsCrafted,
        walletKey: _ArtifactStatusKeys.newspaperWalletKey,
        artifactType: ArtifactType.newspaper,
      ),
      shampoo: _getArtifact(
        requirements: Requirements.shampoo,
        isCraftedKey: _ArtifactStatusKeys.shampooIsCrafted,
        walletKey: _ArtifactStatusKeys.shampooWalletKey,
        artifactType: ArtifactType.shampoo,
      ),
      plant: _getArtifact(
        requirements: Requirements.plant,
        isCraftedKey: _ArtifactStatusKeys.plantIsCrafted,
        walletKey: _ArtifactStatusKeys.plantWalletKey,
        artifactType: ArtifactType.plant,
      ),
      laptop: _getArtifact(
        requirements: Requirements.laptop,
        isCraftedKey: _ArtifactStatusKeys.laptopIsCrafted,
        walletKey: _ArtifactStatusKeys.laptopWalletKey,
        artifactType: ArtifactType.laptop,
      ),
      car: _getArtifact(
        requirements: Requirements.car,
        isCraftedKey: _ArtifactStatusKeys.carIsCrafted,
        walletKey: _ArtifactStatusKeys.carWalletKey,
        artifactType: ArtifactType.car,
      ),
      house: _getArtifact(
        requirements: Requirements.house,
        isCraftedKey: _ArtifactStatusKeys.houseIsCrafted,
        walletKey: _ArtifactStatusKeys.houseWalletKey,
        artifactType: ArtifactType.house,
      ),
    );

    _streamController.add(artifactModel);
  }

  ArtifactModel _getArtifact({
    required ArtifactRequirements requirements,
    required ArtifactType artifactType,
    required String isCraftedKey,
    required String walletKey,
  }) {
    return ArtifactModel(
      requirements: requirements,
      artifactType: artifactType,
      status: _getArtifactStatus(
        isCraftedKey: isCraftedKey,
        walletKey: walletKey,
        requirements: requirements,
      ),
      uuid: _sharedPreferences.getString(walletKey),
    );
  }

  ArtifactStatus _getArtifactStatus({
    required String isCraftedKey,
    required String walletKey,
    required ArtifactRequirements requirements,
  }) {
    if (_sharedPreferences.getString(walletKey)?.isNotEmpty == true) {
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

    final newArtifact = artifact.copyWith(
      status: ArtifactStatus.crafted,
    );

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
    _updateArtifactStatuses();
    _streamController.add(artifactModel);
    _artifactsModel = artifactModel;
    return newArtifact;
  }

  ArtifactModel addToGoogleWallet(ArtifactModel artifact) {
    final uuid = _uuid.v1();
    final newArtifact = artifact.copyWith(
      status: ArtifactStatus.addedToWallet,
      uuid: uuid,
    );

    switch (artifact.artifactType) {
      case ArtifactType.newspaper:
        _artifactsModel = _artifactsModel.copyWith(newspaper: newArtifact);
        _sharedPreferences.setString(
          _ArtifactStatusKeys.newspaperWalletKey,
          uuid,
        );
      case ArtifactType.shampoo:
        _artifactsModel = _artifactsModel.copyWith(shampoo: newArtifact);
        _sharedPreferences.setString(
          _ArtifactStatusKeys.shampooWalletKey,
          uuid,
        );
      case ArtifactType.plant:
        _artifactsModel = _artifactsModel.copyWith(plant: newArtifact);
        _sharedPreferences.setString(
          _ArtifactStatusKeys.plantWalletKey,
          uuid,
        );
      case ArtifactType.laptop:
        _artifactsModel = _artifactsModel.copyWith(laptop: newArtifact);
        _sharedPreferences.setString(
          _ArtifactStatusKeys.laptopWalletKey,
          uuid,
        );
      case ArtifactType.car:
        _artifactsModel = _artifactsModel.copyWith(car: newArtifact);
        _sharedPreferences.setString(
          _ArtifactStatusKeys.carWalletKey,
          uuid,
        );
      case ArtifactType.house:
        _artifactsModel = _artifactsModel.copyWith(house: newArtifact);
        _sharedPreferences.setString(
          _ArtifactStatusKeys.houseWalletKey,
          uuid,
        );
    }

    _streamController.add(artifactModel);
    _artifactsModel = artifactModel;
    return newArtifact;
  }
}

class _ArtifactStatusKeys {
  static const shampooWalletKey = 'artifactsRepositoryStatusShampooInWallet';
  static const shampooIsCrafted = 'artifactsRepositoryStatusShampooIsCrafted';

  static const carWalletKey = 'artifactsRepositoryStatusCarInWallet';
  static const carIsCrafted = 'artifactsRepositoryStatusCarIsCrafted';

  static const plantWalletKey = 'artifactsRepositoryStatusPlantInWallet';
  static const plantIsCrafted = 'artifactsRepositoryStatusPlantIsCrafted';

  static const laptopWalletKey = 'artifactsRepositoryStatusLaptopInWallet';
  static const laptopIsCrafted = 'artifactsRepositoryStatusLaptopIsCrafted';

  static const houseWalletKey = 'artifactsRepositoryStatusHouseInWallet';
  static const houseIsCrafted = 'artifactsRepositoryStatusHouseIsCrafted';

  static const newspaperWalletKey =
      'artifactsRepositoryStatusNewsPaperInWallet';
  static const newspaperIsCrafted =
      'artifactsRepositoryStatusNewsPaperIsCrafted';
}
