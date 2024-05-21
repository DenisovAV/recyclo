import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:recyclo/artifact_details/cubit/artifact_details_state.dart';
import 'package:recyclo/artifact_details/widgets/artifact_crafted_dialog.dart';
import 'package:recyclo/artifacts/artifacts_model.dart';
import 'package:recyclo/artifacts/widgets/artifact_requirements_status.dart';
import 'package:recyclo/artifacts/widgets/artifact_status_icon.dart';
import 'package:recyclo/common.dart';

const _kArtifactRequirementSize = 48.0;

class ArtifactDetailsTv extends StatelessWidget {
  const ArtifactDetailsTv({
    super.key,
  });

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
                              padding: const EdgeInsets.all(12),
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
                                    child: Text(
                                      state.description,
                                      style: context.generalTextStyle(
                                        fontSize: 14,
                                      ),
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
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 380,
                          child: FlatButton(
                            onPressed: () {
                              BlocProvider.of<ArtifactDetailsCubit>(context)
                                  .craftArtifact(state.model);

                              unawaited(
                                showDialog(
                                  context: context,
                                  builder: (_) => GameMessageDialog(
                                    title:
                                        context.l10n.artifactCraftedDialogTitle,
                                    body:
                                        context.l10n.artifactCraftedDialogBody,
                                  ),
                                ),
                              );
                            },
                            isActive: state.model.status ==
                                ArtifactStatus.readyForCraft,
                            text: context.l10n.buttonCraft,
                          ),
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
}

class _ScrollableText extends StatefulWidget {
  const _ScrollableText({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.status,
  });

  final String title;
  final String description;
  final String imagePath;
  final ArtifactStatus status;

  @override
  State<_ScrollableText> createState() => _ScrollableTextState();
}

class _ScrollableTextState extends State<_ScrollableText> {
  final _scrollController = ScrollController();

  bool _showUnderline = true;
  double _imageOffset = 0;

  static const _imageMinHeight = 80.0;
  static const _contentHeight = 120.0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final maxStroke = _scrollController.position.maxScrollExtent;
      final showUnderline = _scrollController.offset < maxStroke;

      setState(() {
        _showUnderline = showUnderline;
        _imageOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38),
                  ),
                  child: Image.asset(
                    widget.imagePath,
                    width: constraints.maxWidth,
                    height: max(
                      _imageMinHeight,
                      min(
                            constraints.maxWidth,
                            constraints.maxHeight - _contentHeight,
                          ) -
                          _imageOffset,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ArtifactStatusIcon(
                      status: widget.status,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Column(
                children: [
                  const SizedBox(height: _imageMinHeight),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          SizedBox(
                            height: min(
                                  constraints.maxWidth,
                                  constraints.maxHeight - _contentHeight,
                                ) -
                                _imageMinHeight,
                          ),
                          ColoredBox(
                            color: FlutterGameChallengeColors.detailsBackground,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  widget.title,
                                  style: context.generalTextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.description,
                                  style: context.generalTextStyle(
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
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: _showUnderline
                          ? FlutterGameChallengeColors.textStroke
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
