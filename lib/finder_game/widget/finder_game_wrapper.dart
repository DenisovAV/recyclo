import 'package:flutter/material.dart';
import 'package:recyclo/common/extensions/platform.dart';
import 'package:recyclo/finder_game/const/finder_constraints.dart';

class FinderGameWrapper extends StatelessWidget {
  const FinderGameWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (ExtendedPlatform.isTv) {
      return child;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: FinderConstraints.maxGameWidth,
        maxHeight: FinderConstraints.maxGameHeight,
        minWidth: FinderConstraints.minGameWith,
        minHeight: FinderConstraints.minGameHeight,
      ),
      child: child,
    );
  }
}
