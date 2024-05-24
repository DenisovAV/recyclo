import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/index.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';
import 'package:recyclo/landing/widgets/landing_item.dart';

class MechanicsWidget extends StatelessWidget {
  const MechanicsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxWidth < 800;

        if (isSmallDevice) {
          return LandingItem(
            color: FlutterGameChallengeColors.mechanicsBackground,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: BrandText(
                        l10n.mechanicsTittle,
                        style: const TextStyle(
                          fontSize: 32,
                          color: FlutterGameChallengeColors.textStroke,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MobileHorizontalWidget(
                    isStart: true,
                    text: l10n.craftingContent,
                    image: Assets.images.craftingScreen.image(),
                  ),
                  if (l10n.walletContent.isNotEmpty) ...[
                    const SizedBox(
                      height: 30,
                    ),
                    MobileHorizontalWidget(
                      isStart: false,
                      text: l10n.walletContent,
                      image: Assets.images.walletScreen.image(),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return LandingItem(
          color: FlutterGameChallengeColors.mechanicsBackground,
          child: Padding(
            padding: EdgeInsets.all(isSmallDevice ? 10 : 50),
            child: Column(
              children: [
                Center(
                  child: BrandText(
                    l10n.mechanicsTittle,
                    style: const TextStyle(
                      fontSize: 48,
                      color: FlutterGameChallengeColors.textStroke,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Assets.images.craftingScreen.image(),
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          BrandText(
                            l10n.craftingContent,
                            style: const TextStyle(
                              color: FlutterGameChallengeColors.textStroke,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          BrandText(
                            l10n.walletContent,
                            style: const TextStyle(
                              color: FlutterGameChallengeColors.textStroke,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Assets.images.walletScreen.image(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
