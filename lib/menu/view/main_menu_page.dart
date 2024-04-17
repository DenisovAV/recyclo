import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/app/view/app.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_cubit.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifacts_list_page.dart';
import 'package:flutter_game_challenge/catcher_game/catcher_game_page.dart';
import 'package:flutter_game_challenge/clicker_game/clicker_game_page.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/finder_game/finder_game_page.dart';
import 'package:flutter_game_challenge/landing/index.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_cubit.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_state.dart';
import 'package:flutter_game_challenge/menu/view/menu_item.dart';
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
    return Scaffold(
      backgroundColor: FlutterGameChallengeColors.blueSky,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<MainPageCubit, MainPageState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvoked: (_) async {
                _onBackBtn(state, context);
                return Future.value(false);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MainMenuBackground(
                    isHighlighted: state.isBackgroundHighlighted,
                    isCompact: state.isBackgroundCompact,
                  ),
                  Positioned.fill(
                    top: 100,
                    left: 20,
                    right: 20,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: switch (state) {
                        MainPageInitialState() => _MainMenuContent(),
                        MainPageChooseGameState() => _ChooseGameContent(),
                        MainPageArtifactDetailsState() => _ArtifactsContent(),
                        MainPageArtifactsState() => _ArtifactsContent(),
                        MainPageTutorialState() => _TutorialContent(),
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: state is! MainPageInitialState ||
                              Navigator.of(context).canPop(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 20,
                            ),
                            child: RoundButton(
                              icon: Icons.keyboard_arrow_left,
                              semanticsLabel: context.l10n.backButtonLabel,
                              onPressed: () => _onBackBtn(state, context),
                            ),
                          ),
                        ),
                        TrashReserveWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onBackBtn(MainPageState state, BuildContext context) {
    if (ExtendedPlatform.isWeb && state is MainPageInitialState) {
      Navigator.of(context).pushReplacement(LandingApp.route());
    } else if (state is MainPageArtifactDetailsState) {
      kNestedNavigatorKey.currentState?.pop();
      BlocProvider.of<MainPageCubit>(context).navigateToArtifacts();
    } else {
      BlocProvider.of<MainPageCubit>(context).navigateToMainPage();
    }
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
              text: context.l10n.mainMenuTutorialItemTitle,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToTutorial();
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
              onTap: () => _handleNavigateToCatcherGame(context),
            ),
            MenuItem(
              text: context.l10n.gameModeClickerItemTitle,
              assetId: Assets.images.gameModeClicker.path,
              onTap: () => _handleNavigateToClickerGame(context),
            ),
            MenuItem(
              text: context.l10n.gameModeFinderItemTitle,
              assetId: Assets.images.gameModeFinder.path,
              onTap: () => _handleNavigateToFinderGame(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigateToCatcherGame(BuildContext context) {
    Navigator.of(context).push<void>(CatcherGamePage.route());
  }

  void _handleNavigateToClickerGame(BuildContext context) {
    Navigator.of(context).push<void>(ClickerGamePage.route());
  }

  void _handleNavigateToFinderGame(BuildContext context) {
    Navigator.of(context).push<void>(FinderGamePage.route());
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

class _TutorialContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      excludeSemantics: true,
      label: context.l10n.mainMenuTutorialItemTitle,
      child: Container(
        decoration: BoxDecoration(
          color: FlutterGameChallengeColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          border: Border(
            top: BorderSide(
              width: 2,
              color: FlutterGameChallengeColors.primary1,
            ),
            left: BorderSide(
              width: 2,
              color: FlutterGameChallengeColors.primary1,
            ),
            right: BorderSide(
              width: 2,
              color: FlutterGameChallengeColors.primary1,
            ),
          ),
        ),
        padding: EdgeInsets.all(28),
        child: Column(
          children: [
            Assets.images.howToPlayWithoutSpaces.image(
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
