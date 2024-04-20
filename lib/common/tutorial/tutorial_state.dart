part of 'tutorial_cubit.dart';

final class TutorialState extends Equatable {
  const TutorialState({
    required this.isTutorialShownBefore,
    required this.isTutorialShown,
  });

  final bool isTutorialShownBefore;
  final bool isTutorialShown;

  @override
  List<Object> get props => [
        isTutorialShownBefore,
        isTutorialShown,
      ];
}
