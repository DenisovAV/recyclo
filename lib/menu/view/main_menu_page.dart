import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/artifacts/artifacts_model.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_cubit.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifact_details.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifacts_list_page.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_cubit.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_state.dart';
import 'package:flutter_game_challenge/menu/widgets/main_menu_background.dart';
import 'package:flutter_game_challenge/service_provider.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_widget.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<MainPageCubit>(create: (_) => MainPageCubit()),
          BlocProvider<TrashReserveCubit>(create: (_) => ServiceProvider.get()),
        ],
        child: const MainMenuPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: FlutterGameChallengeColors.blueSky,
          body: BlocBuilder<MainPageCubit, MainPageState>(
            builder: (context, state) {
              return Stack(
                children: [
                  MainMenuBackground(
                    isHighlighted: state.isBackgroundHighlighted,
                    isCompact: state.isBackgroundCompact,
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12),
                            Visibility(
                              visible: state is! MainPageInitialState,
                              child: GameBackButton(
                                onPressed: () {
                                  if (state is MainPageArtefactDetailsState) {
                                    BlocProvider.of<MainPageCubit>(context)
                                        .navigateToArtifacts();
                                  } else {
                                    BlocProvider.of<MainPageCubit>(context)
                                        .navigateToMainPage();
                                  }
                                },
                              ),
                            ),
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TrashReserveWidget(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Builder(
                                key: ValueKey(state.runtimeType),
                                builder: (context) {
                                  return switch (state) {
                                    MainPageInitialState() =>
                                      _MainMenuContent(),
                                    MainPageChooseGameState() =>
                                      _ChooseGameContent(),
                                    MainPageArtifactsState() =>
                                      _ArtifactsContent(),
                                    MainPageSettingsState() =>
                                      _SettingsContent(),
                                    MainPageArtefactDetailsState() =>
                                      _ArtifactDetailsContent(
                                        description: state.description,
                                        name: state.name,
                                        imagePath: state.imagePath,
                                        model: state.model,
                                      )
                                  };
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.text,
    required this.onTap,
    this.assetId,
    super.key,
  });

  final String text;
  final VoidCallback onTap;
  final String? assetId;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 46,
      fontFamily: 'Mplus',
      height: 2,
      color: FlutterGameChallengeColors.white,
      shadows: [
        Shadow(
          // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: FlutterGameChallengeColors.textStroke,
        ),
        Shadow(
          // bottomRight
          offset: Offset(1.5, -1.5),
          color: FlutterGameChallengeColors.textStroke,
        ),
        Shadow(
          // topRight
          offset: Offset(1.5, 1.5),
          color: FlutterGameChallengeColors.textStroke,
        ),
        Shadow(
          // topLeft
          offset: Offset(-1.5, 1.5),
          color: FlutterGameChallengeColors.textStroke,
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (assetId != null)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(
                assetId!,
                width: 60,
                height: 60,
              ),
            ),
          Text(
            text,
            style: style,
          ),
        ],
      ),
    );
  }
}

class _MainMenuContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 180),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuItem(
              text: context.l10n.mainMenuGamesItemTitle,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToChooseGame();
              },
            ),
            MenuItem(
              text: context.l10n.mainMenuArtifactsItemTitle,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToArtifacts();
              },
            ),
            MenuItem(
              text: context.l10n.mainMenuSettingsItemTitle,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChooseGameContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 180),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuItem(
              text: context.l10n.gameModeCatcherItemTitle,
              assetId: Assets.images.gameModeCathcer.path,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToChooseGame();
              },
            ),
            MenuItem(
              text: context.l10n.gameModeClickerItemTitle,
              assetId: Assets.images.gameModeClicker.path,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToArtifacts();
              },
            ),
            MenuItem(
              text: context.l10n.gameModeFinderItemTitle,
              assetId: Assets.images.gameModeFinder.path,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtifactsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArtifactsCubit>(
      create: (_) => ServiceProvider.get<ArtifactsCubit>(),
      child: const ArtifactsListPage(),
    );
  }
}

class _ArtifactDetailsContent extends StatelessWidget {
  const _ArtifactDetailsContent({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.model,
  });

  final String name;
  final String description;
  final String imagePath;
  final ArtifactModel model;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArtifactsCubit>(
      create: (_) => ServiceProvider.get<ArtifactsCubit>(),
      child: ArtifactDetails(
        name: name,
        imagePath: imagePath,
        description: description,
        model: model,
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterGameChallengeColors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class GameBackButton extends StatelessWidget {
  const GameBackButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            width: 2,
            color: FlutterGameChallengeColors.textStroke,
          ),
        ),
        child: const Icon(
          Icons.keyboard_arrow_left,
          size: 36,
          color: FlutterGameChallengeColors.textStroke,
        ),
      ),
    );
  }
}
