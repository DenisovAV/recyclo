import 'package:recyclo/finder_game/const/finder_constraints.dart';

class FinderGameWidgetSize {
  factory FinderGameWidgetSize.tv() {
    return FinderGameWidgetSize._internal(
      minWidth: double.infinity,
      maxWidth: double.infinity,
      minHeight: double.infinity,
      maxHeight: double.infinity,
    );
  }

  factory FinderGameWidgetSize.mobile() {
    return FinderGameWidgetSize._internal(
      minWidth: FinderConstraints.minGameWidth,
      maxWidth: FinderConstraints.maxGameWidth,
      minHeight: FinderConstraints.minGameHeight,
      maxHeight: FinderConstraints.maxGameHeight,
    );
  }

  FinderGameWidgetSize._internal({
    required this.minWidth,
    required this.minHeight,
    required this.maxWidth,
    required this.maxHeight,
  });

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
}
