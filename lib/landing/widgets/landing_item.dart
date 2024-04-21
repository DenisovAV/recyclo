import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/common/dimensions.dart';

class LandingItem extends StatelessWidget {
  const LandingItem({
    super.key,
    required this.color,
    required this.child,
  });
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxWidth < 850;
        if (isSmallDevice) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 4,
                color: FlutterGameChallengeColors.textStroke,
              ),
            ),
            child: child,
          );
        }

        final desktopConstrains = constraints.maxWidth > 1500
            ? Dimensions.defaultLandingDesktopConstraints
            : Dimensions.landingSmallDesktopConstraints(constraints.maxWidth);

        return Center(
          child: Container(
            constraints: desktopConstrains,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 4,
                color: FlutterGameChallengeColors.textStroke,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Assets.images.up.image(),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Assets.images.down.image(),
                ),
                SizedBox(
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
