import 'package:recyclo/finder_game/const/finder_constraints.dart';

class FinderSize {
  factory FinderSize.tv({
    required double gameSizeY,
  }) {
    final topPadding = gameSizeY * FinderConstraints.topPaddingPercentageTv;

    return FinderSize._internal(
      minWidth: double.infinity,
      maxWidth: double.infinity,
      minHeight: double.infinity,
      maxHeight: double.infinity,
      topPadding: topPadding,
      trashSizeFactor: FinderConstraints.trashSizeFactorTv,
      trashAdditionalTopPaddingPercentage:
          FinderConstraints.trashAdditionalTopPaddingPercentageMobile,
    );
  }

  factory FinderSize.mobile({
    required double gameSizeY,
  }) {
    final topPadding = gameSizeY * FinderConstraints.topPaddingPercentageMobile;

    return FinderSize._internal(
      minWidth: FinderConstraints.minGameWidth,
      maxWidth: FinderConstraints.maxGameWidth,
      minHeight: FinderConstraints.minGameHeight,
      maxHeight: FinderConstraints.maxGameHeight,
      topPadding: topPadding,
      trashSizeFactor: FinderConstraints.trashSizeFactorMobile,
      trashAdditionalTopPaddingPercentage:
          FinderConstraints.trashAdditionalTopPaddingPercentageMobile,
    );
  }

  FinderSize._internal({
    required this.minWidth,
    required this.minHeight,
    required this.maxWidth,
    required this.maxHeight,
    required this.topPadding,
    required this.trashSizeFactor,
    required this.trashAdditionalTopPaddingPercentage,
  });

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final double topPadding;
  final double trashSizeFactor;
  final double trashAdditionalTopPaddingPercentage;
}
