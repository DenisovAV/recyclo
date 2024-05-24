import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/artifacts/artifacts_model.dart';
import 'package:recyclo/artifacts/artifacts_repository.dart';
import 'package:recyclo/artifacts/cubit/artifacts_state.dart';

class ArtifactsCubit extends Cubit<ArtifactsListState> {
  ArtifactsCubit(ArtifactsRepository artifactsRepository)
      : super(
          ArtifactsListState(
            artifacts: artifactsRepository.artifactModel,
          ),
        ) {
    _artifactsStream = artifactsRepository.artifactModelStream.listen((event) {
      emit(ArtifactsListState(artifacts: event));
    });
  }

  StreamSubscription<ArtifactsModel>? _artifactsStream;

  @override
  Future<void> close() {
    _artifactsStream?.cancel();
    return super.close();
  }
}
