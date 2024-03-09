import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/common/dimensions.dart';

class LandingItem extends StatelessWidget {
  final Widget child;
  final Color color;

  const LandingItem({
    super.key,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 850;
      if (isSmallDevice) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(20)),
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
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 4,
              color: FlutterGameChallengeColors.textStroke,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                child: Assets.images.up.image(),
                top: 0,
                left: 0,
              ),
              Positioned(
                child: Assets.images.down.image(),
                right: 0,
                bottom: 0,
              ),
              SizedBox(
                child: child,
              )
            ],
          ),
        ),
      );
    });
  }
}
