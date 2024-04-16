import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/app/view/app.dart';
import 'package:flutter_game_challenge/artifact_details/cubit/artifact_details_cubit.dart';
import 'package:flutter_game_challenge/artifact_details/widgets/artifact_details.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_cubit.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_state.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifact_status_icon.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_cubit.dart';
import 'package:flutter_game_challenge/service_provider.dart';

class ArtifactsListPage extends StatefulWidget {
  const ArtifactsListPage({super.key});

  @override
  State<ArtifactsListPage> createState() => _ArtifactsListPageState();
}

class _ArtifactsListPageState extends State<ArtifactsListPage> {
  final _heroController = HeroController();

  @override
  void dispose() {
    _heroController.dispose();
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
            return LayoutBuilder(builder: (context, constr) {
              return Center(
                child: SizedBox(
                  width: 800,
                  child: GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 40),
                    crossAxisCount: constr.maxWidth < 800 ? 2 : 3,
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
                  ),
                ),
              );
            });
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
  });

  final String name;
  final String? semanticsLabel;
  final ArtifactModel model;
  final String imagePath;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? name,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: FlutterGameChallengeColors.textStroke,
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                              style: context.generalTextStyle(
                                fontSize: 14,
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
      ),
    );
  }
}
