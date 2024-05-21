import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/app/view/app.dart';
import 'package:recyclo/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:recyclo/artifact_details/widgets/artifact_details.dart';
import 'package:recyclo/artifacts/artifacts_model.dart';
import 'package:recyclo/artifacts/cubit/artifacts_cubit.dart';
import 'package:recyclo/artifacts/cubit/artifacts_state.dart';
import 'package:recyclo/artifacts/widgets/artifact_status_icon.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/menu/cubit/main_page_cubit.dart';
import 'package:recyclo/service_provider.dart';
import 'package:recyclo/widgets/focusable.dart';

class ArtifactsListPageTv extends StatefulWidget {
  const ArtifactsListPageTv({super.key});

  @override
  State<ArtifactsListPageTv> createState() => _ArtifactsListPageTvState();
}

class _ArtifactsListPageTvState extends State<ArtifactsListPageTv> {
  final _heroController = HeroController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: [_heroController],
      key: kNestedNavigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => BlocBuilder<ArtifactsCubit, ArtifactsListState>(
          builder: (context, state) {
            return GridView.count(
              shrinkWrap: true,
              controller: _scrollController,
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 80,
                right: 80,
                top: 80,
              ),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _ArtifactItem(
                  name: context.l10n.artifactNewspaperTitle,
                  model: state.artifacts.newspaper,
                  imagePath: Assets.images.artifactNewspaper.path,
                  description: context.l10n.artifactNewspaperDescripton,
                  autofocus: true,
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                _ArtifactItem(
                  name: context.l10n.artifactShampooTitle,
                  model: state.artifacts.shampoo,
                  imagePath: Assets.images.artifactShampoo.path,
                  description: context.l10n.artifactShampooDescripton,
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                _ArtifactItem(
                  name: context.l10n.artifactPlantTitle,
                  model: state.artifacts.plant,
                  imagePath: Assets.images.artifactPlant.path,
                  description: context.l10n.artifactPlantDescripton,
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                _ArtifactItem(
                  name: context.l10n.artifactLaptopTitle,
                  model: state.artifacts.laptop,
                  imagePath: Assets.images.artifactLaptop.path,
                  description: context.l10n.artifactLaptopDescripton,
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                _ArtifactItem(
                  name: context.l10n.artifactCarTitle,
                  model: state.artifacts.car,
                  imagePath: Assets.images.artifactCar.path,
                  description: context.l10n.artifactCarDescripton,
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                _ArtifactItem(
                  name: context.l10n.artifactHouseTitle,
                  model: state.artifacts.house,
                  imagePath: Assets.images.artifactHouse.path,
                  description: context.l10n.artifactHouseDescripton,
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArtifactItem extends StatelessWidget {
  const _ArtifactItem({
    required this.name,
    required this.model,
    required this.imagePath,
    required this.description,
    // ignore: unused_element
    this.semanticsLabel,
    this.onFocusChange,
    this.autofocus = false,
  });

  final String name;
  final String? semanticsLabel;
  final bool autofocus;
  final ArtifactModel model;
  final String imagePath;
  final String description;
  final ValueChanged<bool>? onFocusChange;

  @override
  Widget build(BuildContext context) {
    return Focusable(
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      builder: (context, isFocused) {
        return Semantics(
          label:
              '${semanticsLabel ?? name}.${model.isCrafted ? context.l10n.craftedLabel : context.l10n.notCraftedLabel}',
          enabled: true,
          link: true,
          excludeSemantics: true,
          child: GestureDetector(
            onTap: () {
              Navigator.of(kNestedNavigatorKey.currentContext!).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider<ArtifactDetailsCubit>(
                    create: (_) => ServiceProvider.get<ArtifactDetailsCubit>()
                      ..initialize(
                        name: name,
                        imagePath: imagePath,
                        description: description,
                        model: model,
                      ),
                    child: const ArtifactDetails(),
                  ),
                ),
              );
              BlocProvider.of<MainPageCubit>(context)
                  .navigateToArtifactDetails();
            },
            child: Hero(
              tag: name,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getBackgroundColor(isFocused),
                      ),
                      child: Stack(
                        children: [
                          Image.asset(imagePath),
                          Column(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: ArtifactStatusIcon(
                                    status: model.status,
                                    borderColor: _getBackgroundColor(isFocused),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: _getBackgroundColor(isFocused),
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: context.generalTextStyle(
                                    fontSize: 14,
                                    color: _getForegroundColor(isFocused),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: _getBackgroundColor(isFocused),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(bool isFocused) => isFocused
      ? FlutterGameChallengeColors.toggleSwitchEnabled
      : FlutterGameChallengeColors.textStroke;

  Color _getForegroundColor(bool isFocused) => isFocused
      ? FlutterGameChallengeColors.textStroke
      : FlutterGameChallengeColors.white;
}
