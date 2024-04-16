import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_state.dart';
import 'package:flutter_game_challenge/artifact_details/widgets/artifact_crafted_dialog.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifact_requirements_status.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifact_status_icon.dart';
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
        ArtifactDetailsLoadedState() => Center(
            child: Container(
              width: 480,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                border: Border(
                  top: BorderSide(
                    width: 2,
                    color: FlutterGameChallengeColors.textStroke,
                  ),
                  left: BorderSide(
                    width: 2,
                    color: FlutterGameChallengeColors.textStroke,
                  ),
                  right: BorderSide(
                    width: 2,
                    color: FlutterGameChallengeColors.textStroke,
                  ),
                ),
                color: FlutterGameChallengeColors.detailsBackground,
              ),
              child: LayoutBuilder(
                builder: (context, constr) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Column(
                      children: [
                        Expanded(
                          child: _ScrollableText(
                            title: state.name,
                            description: state.description,
                            imagePath: state.imagePath,
                            status: state.model.status,
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
                                  color:
                                      FlutterGameChallengeColors.categoryGreen,
                                ),
                              if (state.model.requirements.plastic > 0) ...[
                                const SizedBox(width: 4),
                                ArtifactRequirementsStatus(
                                  imagePath: Assets.images.plastic.path,
                                  count: state.model.requirements.plastic,
                                  isEnough: state.trashReserve.plastic >=
                                      state.model.requirements.plastic,
                                  color:
                                      FlutterGameChallengeColors.categoryOrange,
                                ),
                              ],
                              if (state.model.requirements.glass > 0) ...[
                                const SizedBox(width: 4),
                                ArtifactRequirementsStatus(
                                  imagePath: Assets.images.glass.path,
                                  count: state.model.requirements.glass,
                                  isEnough: state.trashReserve.glass >=
                                      state.model.requirements.glass,
                                  color:
                                      FlutterGameChallengeColors.categoryViolet,
                                ),
                              ],
                              if (state.model.requirements.paper > 0) ...[
                                const SizedBox(width: 4),
                                ArtifactRequirementsStatus(
                                  imagePath: Assets.images.paper.path,
                                  count: state.model.requirements.paper,
                                  isEnough: state.trashReserve.paper >=
                                      state.model.requirements.paper,
                                  color:
                                      FlutterGameChallengeColors.categoryPink,
                                ),
                              ],
                              if (state.model.requirements.electronics > 0) ...[
                                const SizedBox(width: 4),
                                ArtifactRequirementsStatus(
                                  imagePath: Assets.images.energy.path,
                                  count: state.model.requirements.electronics,
                                  isEnough: state.trashReserve.electronics >=
                                      state.model.requirements.electronics,
                                  color:
                                      FlutterGameChallengeColors.categoryYellow,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (state.model.status ==
                                ArtifactStatus.readyForCraft ||
                            state.model.status ==
                                ArtifactStatus.notEnoughResources)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                BlocProvider.of<ArtifactDetailsCubit>(context)
                                    .craftArtifact(state.model);

                                unawaited(showDialog(
                                  context: context,
                                  builder: (_) => GameMessageDialog(
                                    title:
                                        context.l10n.artifactCraftedDialogTitle,
                                    body:
                                        context.l10n.artifactCraftedDialogBody,
                                  ),
                                ));
                              },
                              isActive: state.model.status ==
                                  ArtifactStatus.readyForCraft,
                              text: context.l10n.buttonCraft,
                            ),
                          ),
                        _AddToGoogleWallet(
                          artifactStatus: state.model.status,
                          artifactModel: state.model,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      },
    );
  }
}

class _AddToGoogleWallet extends StatelessWidget {
  final ArtifactStatus artifactStatus;
  final ArtifactModel artifactModel;

  const _AddToGoogleWallet({
    required this.artifactStatus,
    required this.artifactModel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Builder(
        key: ValueKey(artifactStatus),
        builder: (_) {
          if (artifactStatus == ArtifactStatus.crafted) {
            return InkWell(
              onTap: () {
                if (ExtendedPlatform.isIos) {
                  return;
                }

                BlocProvider.of<ArtifactDetailsCubit>(context)
                    .addToWallet(artifactModel);
              },
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Builder(
                    builder: (_) {
                      if (ExtendedPlatform.isAndroid) {
                        return Assets.images.addToWalletAndroid.image(
                          height: 52,
                        );
                      }

                      if (ExtendedPlatform.isIos) {
                        return Opacity(
                          opacity: 0.4,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.images.addToWalletIos.image(
                                height: 52,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  context.l10n.featureInProgress,
                                  style: context.generalTextStyle(
                                    fontSize: 14,
                                    color: FlutterGameChallengeColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  )),
            );
          }

          /* if (artifactStatus == ArtifactStatus.addedToWallet) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Assets.images.viewInGoogleWalletAndroid.image(
                height: 52,
              ),
            );
          }*/

          return const SizedBox();
        },
      ),
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
        return Hero(
          tag: widget.title,
          child: Stack(
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
                              color:
                                  FlutterGameChallengeColors.detailsBackground,
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
          ),
        );
      },
    );
  }
}
