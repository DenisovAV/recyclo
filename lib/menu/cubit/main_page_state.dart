abstract class MainPageState {
  MainPageState({
    required this.isBackgroundCompact,
    required this.isBackgroundHighlighted,
  });

  final bool isBackgroundCompact;
  final bool isBackgroundHighlighted;
}

class MainPageInitialState extends MainPageState {
  MainPageInitialState()
      : super(
          isBackgroundCompact: false,
          isBackgroundHighlighted: false,
        );
}

class MainPageChooseGameState extends MainPageState {
  MainPageChooseGameState()
      : super(
          isBackgroundCompact: false,
          isBackgroundHighlighted: true,
        );
}

class MainPageArtifactsState extends MainPageState {
  MainPageArtifactsState()
      : super(
          isBackgroundCompact: true,
          isBackgroundHighlighted: false,
        );
}

class MainPageSettingsState extends MainPageState {
  MainPageSettingsState()
      : super(
          isBackgroundCompact: true,
          isBackgroundHighlighted: false,
        );
}
