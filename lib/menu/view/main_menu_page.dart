import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/app/view/app.dart';
import 'package:flutter_game_challenge/artifacts/cubit/artifacts_cubit.dart';
import 'package:flutter_game_challenge/artifacts/widgets/artifacts_list_page.dart';
import 'package:flutter_game_challenge/catcher_game/catcher_game_page.dart';
import 'package:flutter_game_challenge/clicker_game/clicker_game_page.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/finder_game/finder_game_page.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_cubit.dart';
import 'package:flutter_game_challenge/menu/cubit/main_page_state.dart';
import 'package:flutter_game_challenge/menu/view/menu_item.dart';
import 'package:flutter_game_challenge/menu/widgets/main_menu_background.dart';
import 'package:flutter_game_challenge/service_provider.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_widget.dart';

final GlobalKey _nestedNavigatorKey = GlobalKey();

class MainMenuPage extends StatefulWidget {
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
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final _heroController = HeroController();

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
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
                    bottom: false,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 20),
                            Visibility(
                              visible: state is! MainPageInitialState,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: RoundButton(
                                  icon: Icons.keyboard_arrow_left,
                                  onPressed: () {
                                    if (state is MainPageArtifactDetailsState) {
                                      BlocProvider.of<MainPageCubit>(context)
                                          .navigateToArtifacts();
                                    } else {
                                      BlocProvider.of<MainPageCubit>(context)
                                          .navigateToMainPage();
                                    }

                                    Navigator.of(
                                            _nestedNavigatorKey.currentContext!)
                                        .pop();
                                  },
                                ),
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
                            child: Navigator(
                              key: _nestedNavigatorKey,
                              observers: [_heroController],
                              onGenerateRoute: (_) => MaterialPageRoute(
                                builder: (_) => _MainMenuContent(),
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
                Navigator.of(_nestedNavigatorKey.currentContext!).push(
                  MaterialPageRoute<void>(
                    builder: (_) => _ChooseGameContent(),
                  ),
                );
              },
            ),
            MenuItem(
              text: context.l10n.mainMenuArtifactsItemTitle,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToArtifacts();
                Navigator.of(_nestedNavigatorKey.currentContext!).push(
                  MaterialPageRoute<void>(
                    builder: (_) => _ArtifactsContent(),
                  ),
                );
              },
            ),
            MenuItem(
              text: context.l10n.mainMenuSettingsItemTitle,
              onTap: () {
                BlocProvider.of<MainPageCubit>(context).navigateToSettings();
                Navigator.of(_nestedNavigatorKey.currentContext!).push(
                  MaterialPageRoute<void>(
                    builder: (_) => _SettingsContent(),
                  ),
                );
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
    Navigator.of(kRootNavigatorKey.currentContext!)
        .push<void>(CatcherGamePage.route());
  }

  void _handleNavigateToClickerGame(BuildContext context) {
    Navigator.of(kRootNavigatorKey.currentContext!)
        .push<void>(ClickerGamePage.route());
  }

  void _handleNavigateToFinderGame(BuildContext context) {
   Navigator.of(kRootNavigatorKey.currentContext!)
        .push<void>(FinderGamePage.route());
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
