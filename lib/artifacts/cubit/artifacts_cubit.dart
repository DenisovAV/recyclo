import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_repository.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_state.dart';

class ArtifactsCubit extends Cubit<ArtifactsListState> {
  ArtifactsCubit(ArtifactsRepository artifactsRepository)
      : super(
          ArtifactsListState(
            artifacts: artifactsRepository.artifactModel,
          ),
        );
}
