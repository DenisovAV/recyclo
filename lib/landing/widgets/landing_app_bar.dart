import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/common/dimensions.dart';
import 'package:recyclo/landing/widgets/download_from_stores_widget.dart';
import 'package:recyclo/landing/widgets/landing_logo.dart';

class LandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;

  const LandingAppBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxWidth < 800;

        if (isSmallDevice) {
          return Material(
            elevation: 5,
            color: Colors.transparent,
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
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LandingLogo(
                        fontSize: 24,
                      ),
                      _ScrollToDownButton(
                        onTap: onTap,
                      ),
                    ],
                  ),
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
            child: Material(
              elevation: 5,
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
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
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}

class _ScrollToDownButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ScrollToDownButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 3,
              color: Colors.white,
            ),
          ),
          child: Row(
            children: [
              Text(
                l10n.downloadApp,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 10,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
