import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';
import 'package:recyclo/landing/widgets/landing_item.dart';
import 'package:recyclo/landing/widgets/link_widget.dart';

class AboutUsItem extends StatelessWidget {
  const AboutUsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxWidth < 800;

        return LandingItem(
          color: FlutterGameChallengeColors.aboutAppBackground,
          child: Padding(
            padding: EdgeInsets.all(isSmallDevice ? 10 : 50),
            child: Center(
              child: isSmallDevice
                  ? const _AboutUsMobile()
                  : const _AboutUsDesktop(),
            ),
          ),
        );
      },
    );
  }
}

class _AboutUsDesktop extends StatelessWidget {
  const _AboutUsDesktop();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 900,
      ),
      child: Column(
        children: [
          Center(
            child: BrandText(
              l10n.aboutAppRecycle,
              style: const TextStyle(
                fontSize: 48,
                color: FlutterGameChallengeColors.textStroke,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Assets.images.exampleScreen.image(),
          const SizedBox(
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
          const SizedBox(
            height: 50,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BrandText(
                  l10n.aboutAppRecycleContentTextColumnLeft,
                  style: const TextStyle(
                    fontSize: 20,
                    color: FlutterGameChallengeColors.textStroke,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BrandText(
                      l10n.aboutAppRecycleContentTextColumnRight,
                      style: const TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const LinkWidget(
                      linkColor: FlutterGameChallengeColors.textStroke,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutUsMobile extends StatelessWidget {
  const _AboutUsMobile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Center(
          child: BrandText(
            l10n.aboutAppRecycle,
            style: const TextStyle(
              fontSize: 32,
              color: FlutterGameChallengeColors.textStroke,
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Assets.images.exampleScreenMobile.image(),
        const SizedBox(
          height: 25,
        ),
        BrandText(
          l10n.aboutAppRecycleContentTextColumnLeft,
          style: const TextStyle(
            fontSize: 16,
            color: FlutterGameChallengeColors.textStroke,
          ),
        ),
        BrandText(
          l10n.aboutAppRecycleContentTextColumnRight,
          style: const TextStyle(
            fontSize: 16,
            color: FlutterGameChallengeColors.textStroke,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        const LinkWidget(
          linkColor: FlutterGameChallengeColors.textStroke,
        ),
      ],
    );
  }
}
