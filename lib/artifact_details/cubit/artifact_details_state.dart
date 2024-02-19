import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_repository.dart';

sealed class ArtifactDetailsState {}

class ArtifactDetailsEmptyState extends ArtifactDetailsState {}

class ArtifactDetailsLoadedState extends ArtifactDetailsState {
  ArtifactDetailsLoadedState({
    required this.trashReserve,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.model,
  });

  final TrashReserveModel trashReserve;
  final String imagePath;
  final String name;
  final String description;
  final ArtifactModel model;

  ArtifactDetailsLoadedState copyWithModel(ArtifactModel model) {
    return ArtifactDetailsLoadedState(
      name: name,
      description: description,
      trashReserve: trashReserve,
      imagePath: imagePath,
      model: model,
    );
  }
}
