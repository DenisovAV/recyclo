import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_state.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifact_requirements_status.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifact_status_icon.dart';
import 'package:flutter_game_challenge/artifacts/widgets/game_button.dart';
import 'package:flutter_game_challenge/common.dart';

class ArtifactDetails extends StatelessWidget {
  const ArtifactDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtifactDetailsCubit, ArtifactDetailsState>(
      builder: (context, state) => switch (state) {
        ArtifactDetailsEmptyState() => const SizedBox(),
        ArtifactDetailsLoadedState() => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                width: 2,
                color: FlutterGameChallengeColors.textStroke,
              ),
              color: FlutterGameChallengeColors.detailsBackground,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              child: Image.asset(state.imagePath),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: ArtifactStatusIcon(
                                  status: state.model.status,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                state.name,
                                style: const TextStyle(
                                  color: FlutterGameChallengeColors.textStroke,
                                  fontSize: 36,
                                ),
                              ),
                              Text(
                                state.description,
                                style: const TextStyle(
                                  color: FlutterGameChallengeColors.textStroke,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.model.requirements.organic > 0)
                        ArtifactRequirementsStatus(
                          imagePath: Assets.images.organic.path,
                          count: state.model.requirements.organic,
                          isEnough: state.trashReserve.organic >=
                              state.model.requirements.organic,
                          color: FlutterGameChallengeColors.categoryGreen,
                        ),
                      if (state.model.requirements.plastic > 0) ...[
                        const SizedBox(width: 4),
                        ArtifactRequirementsStatus(
                          imagePath: Assets.images.plastic.path,
                          count: state.model.requirements.plastic,
                          isEnough: state.trashReserve.plastic >=
                              state.model.requirements.plastic,
                          color: FlutterGameChallengeColors.categoryViolet,
                        ),
                      ],
                      if (state.model.requirements.glass > 0) ...[
                        const SizedBox(width: 4),
                        ArtifactRequirementsStatus(
                          imagePath: Assets.images.glass.path,
                          count: state.model.requirements.glass,
                          isEnough: state.trashReserve.glass >=
                              state.model.requirements.glass,
                          color: FlutterGameChallengeColors.categoryOrange,
                        ),
                      ],
                      if (state.model.requirements.paper > 0) ...[
                        const SizedBox(width: 4),
                        ArtifactRequirementsStatus(
                          imagePath: Assets.images.paper.path,
                          count: state.model.requirements.paper,
                          isEnough: state.trashReserve.paper >=
                              state.model.requirements.paper,
                          color: FlutterGameChallengeColors.categoryYellow,
                        ),
                      ],
                      if (state.model.requirements.electronics > 0) ...[
                        const SizedBox(width: 4),
                        ArtifactRequirementsStatus(
                          imagePath: Assets.images.energy.path,
                          count: state.model.requirements.electronics,
                          isEnough: state.trashReserve.electronics >=
                              state.model.requirements.electronics,
                          color: FlutterGameChallengeColors.categoryPink,
                        ),
                      ],
                    ],
                  ),
                ),
                if (state.model.status == ArtifactStatus.readyForCraft ||
                    state.model.status == ArtifactStatus.notEnoughResources)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: GameButton(
                      onPressed: () {
                        BlocProvider.of<ArtifactDetailsCubit>(context)
                            .craftArtifact(state.model);
                      },
                      isActive:
                          state.model.status == ArtifactStatus.readyForCraft,
                      text: context.l10n.buttonCraft,
                    ),
                  ),
                if (state.model.status == ArtifactStatus.crafted)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Assets.images.addToWallet.image(
                      height: 52,
                    ),
                  ),
              ],
            ),
          ),
      },
    );
  }
}
