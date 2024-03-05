import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_state.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_repository.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';

class ArtifactDetailsCubit extends Cubit<ArtifactDetailsState> {
  ArtifactDetailsCubit(
    this._artifactsRepository,
    this._trashReserveRepository,
  ) : super(
          ArtifactDetailsEmptyState(),
        );

  final ArtifactsRepository _artifactsRepository;
  final TrashReserveRepository _trashReserveRepository;

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

  void craftArtifact(ArtifactModel model) {
    final updatedArtifact = _artifactsRepository.craftArtifact(model);

    emit((state as ArtifactDetailsLoadedState).copyWithModel(updatedArtifact));
  }

  void addToWallet(ArtifactModel artifact) {
    final updatedArtifact = _artifactsRepository.addToGoogleWallet(artifact);

    emit((state as ArtifactDetailsLoadedState).copyWithModel(updatedArtifact));
  }
}
