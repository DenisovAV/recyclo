import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';
import 'package:recyclo/landing/widgets/download_button.dart';
import 'package:recyclo/landing/widgets/landing_item.dart';

class WebOsItem extends StatelessWidget {
  const WebOsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxWidth < 900;

        return LandingItem(
          color: FlutterGameChallengeColors.primary1,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(isSmallDevice ? 10 : 50),
                child: Center(
                  child: isSmallDevice ? const _WebOsMobile() : const _WebOsDesktop(),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: constraints.maxWidth - 250),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                    child: Assets.images.remoteControl.image(),
                  ),
                ),
              ),
              if (!isSmallDevice)
                Positioned(bottom: 15, right: 15, child: Assets.images.lgLogo.image()),
            ],
          ),
        );
      },
    );
  }
}

class _WebOsDesktop extends StatelessWidget {
  const _WebOsDesktop();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        children: [
          Center(child: Assets.images.webosLogo.image()),
          const SizedBox(height: 50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Assets.images.plant.image(),
              Assets.images.tvGameplay.image(),
              Assets.images.lamp.image(),
            ],
          ),
          const SizedBox(height: 50),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: l10n.yourSmartTv,
                style: const TextStyle(
                  fontFamily: FontFamily.sourceSansPro,
                  fontSize: 20,
                  color: FlutterGameChallengeColors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: l10n.webOsDescription1,
                    style: const TextStyle(
                      fontFamily: FontFamily.sourceSansPro,
                      fontSize: 20,
                      color: FlutterGameChallengeColors.webosTextColor,
                    ),
                  ),
                  TextSpan(
                    text: l10n.lgMagicRemote,
                  ),
                  TextSpan(
                    text: l10n.toPlayRightNow,
                    style: const TextStyle(
                      fontFamily: FontFamily.sourceSansPro,
                      fontSize: 20,
                      color: FlutterGameChallengeColors.webosTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          DownloadButton(
            image: Assets.images.lgConectStore.image(),
            url: 'https://play.google.com/store/apps/details?id=dev.recyclo.games',
          ),
        ],
      ),
    );
  }
}

class _WebOsMobile extends StatelessWidget {
  const _WebOsMobile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Center(child: Assets.images.webosLogo.image()),
        const SizedBox(height: 25),
        Assets.images.tvGameplay.image(),
        Assets.images.lgLogo.image(),
        const SizedBox(height: 25),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: l10n.yourSmartTv,
              style: const TextStyle(
                fontFamily: FontFamily.sourceSansPro,
                fontSize: 16,
                color: FlutterGameChallengeColors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: l10n.webOsDescription1,
                  style: const TextStyle(
                    fontFamily: FontFamily.sourceSansPro,
                    fontSize: 16,
                    color: FlutterGameChallengeColors.webosTextColor,
                  ),
                ),
                TextSpan(text: l10n.lgMagicRemote),
                TextSpan(
                  text: l10n.toPlayRightNow,
                  style: const TextStyle(
                    fontFamily: FontFamily.sourceSansPro,
                    fontSize: 16,
                    color: FlutterGameChallengeColors.webosTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
