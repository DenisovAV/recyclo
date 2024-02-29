import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:flutter_game_challenge/artifact_details/widgets/artifact_details.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_cubit.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_state.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifact_status_icon.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_cubit.dart';
import 'package:flutter_game_challenge/service_provider.dart';

class ArtifactsListPage extends StatelessWidget {
  const ArtifactsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtifactsCubit, ArtifactsListState>(
      builder: (context, state) {
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _ArtifactItem(
              name: context.l10n.artifactNewspaperTitle,
              model: state.artifacts.newspaper,
              imagePath: Assets.images.artifactNewspaper.path,
              description: context.l10n.artifactNewspaperDescripton,
            ),
            _ArtifactItem(
              name: context.l10n.artifactShampooTitle,
              model: state.artifacts.shampoo,
              imagePath: Assets.images.artifactShampoo.path,
              description: context.l10n.artifactShampooDescripton,
            ),
            _ArtifactItem(
              name: context.l10n.artifactPlantTitle,
              model: state.artifacts.plant,
              imagePath: Assets.images.artifactPlant.path,
              description: context.l10n.artifactPlantDescripton,
            ),
            _ArtifactItem(
              name: context.l10n.artifactLaptopTitle,
              model: state.artifacts.laptop,
              imagePath: Assets.images.artifactLaptop.path,
              description: context.l10n.artifactLaptopDescripton,
            ),
            _ArtifactItem(
              name: context.l10n.artifactCarTitle,
              model: state.artifacts.car,
              imagePath: Assets.images.artifactCar.path,
              description: context.l10n.artifactCarDescripton,
            ),
            _ArtifactItem(
              name: context.l10n.artifactHouseTitle,
              model: state.artifacts.house,
              imagePath: Assets.images.artifactHouse.path,
              description: context.l10n.artifactHouseDescripton,
            ),
          ],
        );
      },
    );
  }
}

class _ArtifactItem extends StatelessWidget {
  const _ArtifactItem({
    required this.name,
    required this.model,
    required this.imagePath,
    required this.description,
  });

  final String name;
  final ArtifactModel model;
  final String imagePath;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider<ArtifactDetailsCubit>(
              create: (_) => ServiceProvider.get<ArtifactDetailsCubit>()
                ..initialize(
                    name: name,
                    imagePath: imagePath,
                    description: description,
                    model: model),
              child: ArtifactDetails(),
            ),
          ),
        );
        BlocProvider.of<MainPageCubit>(context).navigateToArtifactDetails();
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
                decoration: const BoxDecoration(
                  color: FlutterGameChallengeColors.textStroke,
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
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: FlutterGameChallengeColors.textStroke,
                          child: Text(
                            name,
                            style: context.generalTextStyle(
                              fontSize: 18,
                              color: FlutterGameChallengeColors.white,
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
                  color: FlutterGameChallengeColors.textStroke,
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
    );
  }
}
