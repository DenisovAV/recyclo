abstract class MainPageState {
  MainPageState({
    required this.isBackgroundCompact,
    required this.isBackgroundHighlighted,
  });

  final bool isBackgroundCompact;
  final bool isBackgroundHighlighted;
}

sealed class MainPageInitialState extends MainPageState {
  MainPageInitialState()
      : super(
          isBackgroundCompact: false,
          isBackgroundHighlighted: false,
        );
}

sealed class MainPageChooseGameState extends MainPageState {
  MainPageChooseGameState()
      : super(
          isBackgroundCompact: false,
          isBackgroundHighlighted: true,
        );
}

sealed class MainPageArtifactsState extends MainPageState {
  MainPageArtifactsState()
      : super(
          isBackgroundCompact: true,
          isBackgroundHighlighted: false,
        );
}

sealed class MainPageSettingsState extends MainPageState {
  MainPageSettingsState()
      : super(
          isBackgroundCompact: true,
          isBackgroundHighlighted: false,
        );
}
