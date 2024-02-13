import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/requirements.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtifactsRepository {
  ArtifactsRepository(this._trashReserveRepository);

  late final SharedPreferences _sharedPreferences;
  late final ArtifactsModel _artifactsModel;
  
  final TrashReserveRepository _trashReserveRepository;

  ArtifactsModel get artifactModel => _artifactsModel;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _artifactsModel = ArtifactsModel(
      shampoo: _getArtifact(
        requirements: Requirements.shampoo,
        isCraftedKey: _ArtifactStatusKeys.shampooIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.shampooInWallet,
      ),
      car: _getArtifact(
        requirements: Requirements.car,
        isCraftedKey: _ArtifactStatusKeys.carIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.carInWallet,
      ),
      plant: _getArtifact(
        requirements: Requirements.plant,
        isCraftedKey: _ArtifactStatusKeys.plantIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.plantInWallet,
      ),
      laptop: _getArtifact(
        requirements: Requirements.laptop,
        isCraftedKey: _ArtifactStatusKeys.laptopIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.laptopInWallet,
      ),
      house: _getArtifact(
        requirements: Requirements.house,
        isCraftedKey: _ArtifactStatusKeys.houseIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.houseInWallet,
      ),
      newspaper: _getArtifact(
        requirements: Requirements.newspaper,
        isCraftedKey: _ArtifactStatusKeys.newspaperIsCrafted,
        isInWalletKey: _ArtifactStatusKeys.newspaperInWallet,
      ),
    );
  }

  ArtifactModel _getArtifact({
    required ArtifactRequirements requirements,
    required String isCraftedKey,
    required String isInWalletKey,
  }) {
    return ArtifactModel(
      requirements: Requirements.shampoo,
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

    return reservedTrash.energy >= requirements.energy &&
        reservedTrash.glass >= requirements.glass &&
        reservedTrash.organic >= requirements.organic &&
        reservedTrash.paper >= requirements.paper &&
        reservedTrash.plastic >= requirements.plastic;
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
