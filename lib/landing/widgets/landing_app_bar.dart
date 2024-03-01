import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/common/dimensions.dart';
import 'package:flutter_game_challenge/landing/widgets/download_from_stores_widget.dart';
import 'package:flutter_game_challenge/landing/widgets/landing_logo.dart';

class LandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LandingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxWidth < 800;

        if (isSmallDevice) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: FlutterGameChallengeColors.textStroke,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LandingLogo(),
                  ],
                ),
              ),
            ),
          );
        }

        final desktopConstrains = constraints.maxWidth > 1500
            ? Dimensions.defaultLandingDesktopConstraints
            : Dimensions.landingSmallDesktopConstraints(constraints.maxWidth);

        return Center(
          child: ConstrainedBox(
            constraints: desktopConstrains,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: FlutterGameChallengeColors.textStroke,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LandingLogo(),
                      DownloadFromStoresWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
