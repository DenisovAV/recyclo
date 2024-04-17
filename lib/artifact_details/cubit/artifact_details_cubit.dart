import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_state.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_repository.dart';
import 'package:flutter_game_challenge/artifacts/wallet/service/wallet_interface.dart';
import 'package:flutter_game_challenge/audio/music_service.dart';
import 'package:flutter_game_challenge/audio/sounds.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';

class ArtifactDetailsCubit extends Cubit<ArtifactDetailsState> {
  ArtifactDetailsCubit(
    this._artifactsRepository,
    this._trashReserveRepository,
    this._walletService,
    this._musicService,
  ) : super(
          ArtifactDetailsEmptyState(),
        );

  final ArtifactsRepository _artifactsRepository;
  final TrashReserveRepository _trashReserveRepository;
  final WalletService _walletService;
  final MusicService _musicService;

  void initialize({
    required String name,
    required String imagePath,
    required String description,
    required ArtifactModel model,
  }) {
    emit(
      ArtifactDetailsLoadedState(
        trashReserve: _trashReserveRepository.reservedTrash,
        imagePath: imagePath,
        name: name,
        description: description,
        model: model,
      ),
    );
  }

  void craftArtifact(ArtifactModel model) async {
    final updatedArtifact = _artifactsRepository.craftArtifact(model);

    await _musicService.playSound(Sounds.artifactCrafted);

    emit((state as ArtifactDetailsLoadedState).copyWithModel(updatedArtifact));
  }

  void addToWallet(ArtifactModel artifact) {
    final updatedArtifact = _artifactsRepository.addToGoogleWallet(artifact);
    try {
      _walletService.addToWallet(
          updatedArtifact.artifactType, updatedArtifact.uuid!);
      emit(
          (state as ArtifactDetailsLoadedState).copyWithModel(updatedArtifact));
    } catch (e) {
      print("Failed to add to wallet: '${e}'.");
    }
  }
}
