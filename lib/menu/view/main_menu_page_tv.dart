import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recyclo/app/view/app.dart';
import 'package:recyclo/catcher_game/catcher_game_page.dart';
import 'package:recyclo/clicker_game/clicker_game_page.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/finder_game/finder_game_page.dart';
import 'package:recyclo/landing/app/landing_app.dart';
import 'package:recyclo/menu/cubit/main_page_cubit.dart';
import 'package:recyclo/menu/cubit/main_page_state.dart';
import 'package:recyclo/trash_reserve/trash_reserve_widget.dart';
import 'package:recyclo/widgets/focusable.dart';
import 'package:video_player/video_player.dart';

class MainMenuPageTv extends StatefulWidget {
  const MainMenuPageTv({super.key});

  @override
  State<MainMenuPageTv> createState() => _MainMenuPageTvState();
}

class _MainMenuPageTvState extends State<MainMenuPageTv> {
  late final VideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();

    _playerController = VideoPlayerController.asset(Assets.images.earth)
      ..setLooping(true)
      ..play()
      ..initialize().then((_) {
        setState(() {});
      });

    _playerController.addListener(_onPlayerStopped);
  }

  void _onPlayerStopped() {
    if (!_playerController.value.isPlaying) {
      _playerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterGameChallengeColors.blueSky,
      body: Stack(
        children: [
          Assets.images.tvBackground.image(
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
              offset: const Offset(80, 80),
              child: SizedBox(
                width: 340,
                height: 340,
                child: Stack(
                  children: [
                    Assets.images.earthHalo.image(
                      color: FlutterGameChallengeColors.earthGlow,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: AspectRatio(
                        aspectRatio: _playerController.value.aspectRatio,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(170),
                          child: Semantics(
                            label: context.l10n.earthAnimation,
                            child: VideoPlayer(_playerController),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: BlocBuilder<MainPageCubit, MainPageState>(
              builder: (context, state) {
                return PopScope(
                  canPop: false,
                  onPopInvoked: (_) async {
                    _onBackBtn(state, context);
                    return Future.value();
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: switch (state) {
                      MainPageInitialState() => _MainMenuContent(),
                      MainPageChooseGameState() => _ChooseGameContent(),
                      MainPageArtifactDetailsState() => const SizedBox(),
                      MainPageArtifactsState() => const SizedBox(),
                      MainPageTutorialState() => const SizedBox(),
                      MainPageSettingsState() => const SizedBox(),
                    },
                  ),
                );
              },
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: TrashReserveWidget(),
          ),
        ],
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

class _ChooseGameContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _MainMenuItem(
            autofocus: true,
            title: context.l10n.gameModeCatcherItemTitle,
            iconPath: Assets.images.games.path,
            selectedIconPath: Assets.images.gamesSelected.path,
            onTap: () {
              BlocProvider.of<MainPageCubit>(context).navigateToCatcherGame(
                (gameType) => _handleNavigateToGameType(
                  gameType: gameType,
                  context: context,
                ),
              );
            },
          ),
          _MainMenuItem(
            title: context.l10n.gameModeClickerItemTitle,
            iconPath: Assets.images.artifacts.path,
            selectedIconPath: Assets.images.artifactsSelected.path,
            onTap: () {
              BlocProvider.of<MainPageCubit>(context).navigateToClickerGame(
                (gameType) => _handleNavigateToGameType(
                  gameType: gameType,
                  context: context,
                ),
              );
            },
          ),
          _MainMenuItem(
            title: context.l10n.gameModeFinderItemTitle,
            iconPath: Assets.images.tutorial.path,
            selectedIconPath: Assets.images.tutorialSelected.path,
            onTap: () {
              BlocProvider.of<MainPageCubit>(context).navigateToFinderGame(
                (gameType) => _handleNavigateToGameType(
                  gameType: gameType,
                  context: context,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleNavigateToGameType({
    required GameType gameType,
    required BuildContext context,
  }) async {
    switch (gameType) {
      case GameType.catcher:
        await Navigator.of(context).push<void>(CatcherGamePage.route());
        break;
      case GameType.clicker:
        await Navigator.of(context).push<void>(ClickerGamePage.route());
        break;
      case GameType.finder:
        await Navigator.of(context).push<void>(FinderGamePage.route());
        break;
    }
  }
}

class _MainMenuContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _MainMenuItem(
            autofocus: true,
            title: context.l10n.mainMenuGamesItemTitle,
            iconPath: Assets.images.games.path,
            selectedIconPath: Assets.images.gamesSelected.path,
            onTap: () {
              BlocProvider.of<MainPageCubit>(context).navigateToChooseGame();
            },
          ),
          _MainMenuItem(
            title: context.l10n.mainMenuArtifactsItemTitle,
            iconPath: Assets.images.artifacts.path,
            selectedIconPath: Assets.images.artifactsSelected.path,
            onTap: () {},
          ),
          _MainMenuItem(
            title: context.l10n.mainMenuTutorialItemTitle,
            iconPath: Assets.images.tutorial.path,
            selectedIconPath: Assets.images.tutorialSelected.path,
            onTap: () {},
          ),
          _MainMenuItem(
            title: context.l10n.mainMenuSettingsItemTitle,
            iconPath: Assets.images.settings.path,
            selectedIconPath: Assets.images.settingsSelected.path,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _MainMenuItem extends StatefulWidget {
  const _MainMenuItem({
    required this.title,
    required this.iconPath,
    required this.selectedIconPath,
    required this.onTap,
    this.autofocus = false,
  });

  final String title;
  final String iconPath;
  final String selectedIconPath;
  final VoidCallback onTap;
  final bool autofocus;

  @override
  State<_MainMenuItem> createState() => _MainMenuItemState();
}

class _MainMenuItemState extends State<_MainMenuItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.6,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focusable(
      autofocus: widget.autofocus,
      onFocusChange: (newValue) {
        if (newValue) {
          _controller
            ..animateTo(0, duration: Duration.zero)
            ..forward();
        }
      },
      builder: (context, isFocused) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _controller,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    key: ValueKey(isFocused),
                    isFocused ? widget.selectedIconPath : widget.iconPath,
                    width: 60,
                  ),
                ),
              ),
              const SizedBox(width: 32),
              AnimatedDefaultTextStyle(
                style: context.textStyle(height: 1.6).copyWith(
                      color: isFocused
                          ? FlutterGameChallengeColors.gamesBackground
                          : FlutterGameChallengeColors.white,
                    ),
                duration: const Duration(milliseconds: 200),
                child: Text(widget.title),
              ),
            ],
          ),
        );
      },
    );
  }
}