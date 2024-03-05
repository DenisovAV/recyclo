import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/widgets/brand_text.dart';
import 'package:flutter_game_challenge/landing/widgets/landing_item.dart';
import 'package:flutter_game_challenge/landing/widgets/link_widget.dart';

class AboutUsItem extends StatelessWidget {
  const AboutUsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 800;

      return LandingItem(
        color: FlutterGameChallengeColors.textStroke,
        child: Padding(
          padding: EdgeInsets.all(isSmallDevice ? 10 : 50),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 1000,
              ),
              child: Column(
                children: [
                  Center(
                    child: BrandText(
                      l10n.aboutAppRecycle,
                      style: TextStyle(
                        fontSize: 48,
                        color: FlutterGameChallengeColors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Assets.images.logoDescription.image(
                        width: constraints.maxWidth,
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: BrandText(
                          l10n.aboutAppRecycleContentTextColumnLeft,
                          style: TextStyle(
                            fontSize: 20,
                            color: FlutterGameChallengeColors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BrandText(
                              l10n.aboutAppRecycleContentTextColumnRight,
                              style: TextStyle(
                                fontSize: 20,
                                color: FlutterGameChallengeColors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            const LinkWidget(),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
