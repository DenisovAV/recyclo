import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:recyclo/artifact_details/cubit/artifact_details_state.dart';
import 'package:recyclo/artifact_details/widgets/artifact_crafted_dialog.dart';
import 'package:recyclo/artifacts/artifacts_model.dart';
import 'package:recyclo/artifacts/widgets/artifact_requirements_status.dart';
import 'package:recyclo/artifacts/widgets/artifact_status_icon.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/widgets/focusable.dart';
import 'package:recyclo/widgets/tv_button.dart';

const _kArtifactRequirementSize = 48.0;

class ArtifactDetailsTv extends StatefulWidget {
  const ArtifactDetailsTv({
    super.key,
  });

  @override
  State<ArtifactDetailsTv> createState() => _ArtifactDetailsTvState();
}

class _ArtifactDetailsTvState extends State<ArtifactDetailsTv> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtifactDetailsCubit, ArtifactDetailsState>(
      builder: (context, state) => switch (state) {
        ArtifactDetailsEmptyState() => const SizedBox(),
        ArtifactDetailsLoadedState() => Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                width: 640,
                height: 300,
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
                      child: Row(
                        children: [
                          Hero(
                            tag: state.name,
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        state.imagePath,
                                        fit: BoxFit.fill,
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: ArtifactStatusIcon(
                                          status: state.model.status,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Focusable(
                                      onKeyEvent: _onKeyPressed,
                                      autofocus: true,
                                      builder: (context, isFocused) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              width: 2.0,
                                              color: FlutterGameChallengeColors
                                                  .artifactGreen
                                                  .withOpacity(
                                                isFocused ? 1 : 0,
                                              ),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                state.name,
                                                style: context.generalTextStyle(
                                                  fontSize: 28,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  controller: _scrollController,
                                                  child: Text(
                                                    state.description,
                                                    style: context
                                                        .generalTextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  MergeSemantics(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      children: [
                                        if (state.model.requirements.organic >
                                            0)
                                          ArtifactRequirementsStatus(
                                            width: _kArtifactRequirementSize,
                                            type: ItemType.organic,
                                            count: state
                                                .model.requirements.organic,
                                            isEnough:
                                                state.trashReserve.organic >=
                                                    state.model.requirements
                                                        .organic,
                                            color: FlutterGameChallengeColors
                                                .categoryGreen,
                                          ),
                                        if (state.model.requirements.plastic >
                                            0) ...[
                                          const SizedBox(width: 4),
                                          ArtifactRequirementsStatus(
                                            width: _kArtifactRequirementSize,
                                            type: ItemType.plastic,
                                            count: state
                                                .model.requirements.plastic,
                                            isEnough:
                                                state.trashReserve.plastic >=
                                                    state.model.requirements
                                                        .plastic,
                                            color: FlutterGameChallengeColors
                                                .categoryOrange,
                                          ),
                                        ],
                                        if (state.model.requirements.glass >
                                            0) ...[
                                          const SizedBox(width: 4),
                                          ArtifactRequirementsStatus(
                                            width: _kArtifactRequirementSize,
                                            type: ItemType.glass,
                                            count:
                                                state.model.requirements.glass,
                                            isEnough: state
                                                    .trashReserve.glass >=
                                                state.model.requirements.glass,
                                            color: FlutterGameChallengeColors
                                                .categoryViolet,
                                          ),
                                        ],
                                        if (state.model.requirements.paper >
                                            0) ...[
                                          const SizedBox(width: 4),
                                          ArtifactRequirementsStatus(
                                            width: _kArtifactRequirementSize,
                                            type: ItemType.paper,
                                            count:
                                                state.model.requirements.paper,
                                            isEnough: state
                                                    .trashReserve.paper >=
                                                state.model.requirements.paper,
                                            color: FlutterGameChallengeColors
                                                .categoryPink,
                                          ),
                                        ],
                                        if (state.model.requirements
                                                .electronics >
                                            0) ...[
                                          const SizedBox(width: 4),
                                          ArtifactRequirementsStatus(
                                            width: _kArtifactRequirementSize,
                                            type: ItemType.electronic,
                                            count: state
                                                .model.requirements.electronics,
                                            isEnough: state
                                                    .trashReserve.electronics >=
                                                state.model.requirements
                                                    .electronics,
                                            color: FlutterGameChallengeColors
                                                .categoryYellow,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.model.status == ArtifactStatus.readyForCraft ||
                        state.model.status == ArtifactStatus.notEnoughResources)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TvButton(
                          text: context.l10n.buttonCraft,
                          onPressed: () {
                            BlocProvider.of<ArtifactDetailsCubit>(context)
                                .craftArtifact(state.model);

                            unawaited(
                              showDialog(
                                context: context,
                                builder: (_) => GameMessageDialog(
                                  title:
                                      context.l10n.artifactCraftedDialogTitle,
                                  body: context.l10n.artifactCraftedDialogBody,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
      },
    );
  }

  KeyEventResult _onKeyPressed(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
        _scrollController.offset > 0) {
      _scrollController.animateTo(
        math.max(
          0,
          _scrollController.offset - 100,
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
      );

      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
        _scrollController.offset < _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        math.min(
          _scrollController.position.maxScrollExtent,
          _scrollController.offset + 100,
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
      );

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
