import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/index.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';
import 'package:recyclo/landing/widgets/landing_item.dart';
import 'package:recyclo/landing/widgets/mobile_vertical_widget.dart';

class GamesItem extends StatelessWidget {
  const GamesItem({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 850;

      return LandingItem(
        color: FlutterGameChallengeColors.gamesBackground,
        child: Padding(
          padding: isSmallDevice
              ? EdgeInsets.symmetric(
                  vertical: 15,
                )
              : EdgeInsets.all(50),
          child: Column(
            children: [
              Center(
                child: BrandText(
                  l10n.gamesTitle,
                  style: TextStyle(
                    fontSize: isSmallDevice ? 32 : 48,
                    color: FlutterGameChallengeColors.textStroke,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallDevice ? 10 : 0),
                child: BrandText(
                  l10n.gamesDescription,
                  style: TextStyle(
                    fontSize: isSmallDevice ? 16 : 20,
                    color: FlutterGameChallengeColors.textStroke,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _Game1(),
              _Game2(),
              _Game3(),
            ],
          ),
        ),
      );
    });
  }
}

class _Game1 extends StatelessWidget {
  const _Game1();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 800;

      if (isSmallDevice) {
        return MobileVerticalWidget(
          title: l10n.game1Title,
          text: l10n.game1Description,
          image: Assets.images.screenshotGame1.image(),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Assets.images.screenshotGame1.image(),
          GameDescription(
            title: l10n.game1Title,
            description: l10n.game1Description,
          ),
        ],
      );
    });
  }
}

class _Game2 extends StatelessWidget {
  const _Game2();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 800;

      if (isSmallDevice) {
        return MobileHorizontalWidget(
          isStart: true,
          title: l10n.game2Title,
          text: l10n.game2Description,
          image: Assets.images.screenshotGame2.image(),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GameDescription(
            isLeft: false,
            title: l10n.game2Title,
            description: l10n.game2Description,
          ),
          Assets.images.screenshotGame2.image(),
        ],
      );
    });
  }
}

class _Game3 extends StatelessWidget {
  const _Game3();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 800;

      if (isSmallDevice) {
        return MobileHorizontalWidget(
          isStart: false,
          title: l10n.game3Title,
          text: l10n.game3Description,
          image: Assets.images.screenshotGame3.image(),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Assets.images.screenshotGame3.image(),
          GameDescription(
            title: l10n.game3Title,
            description: l10n.game3Description,
          ),
        ],
      );
    });
  }
}

class GameDescription extends StatelessWidget {
  final String title;
  final String description;
  final bool isLeft;

  const GameDescription({
    super.key,
    required this.title,
    required this.description,
    this.isLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: isLeft ? 50 : 0,
          right: isLeft ? 0 : 50,
        ),
        child: Column(
          crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            BrandText(
              title,
              style: TextStyle(
                fontSize: 32,
                color: FlutterGameChallengeColors.textStroke,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            BrandText(
              description,
              textAlign: isLeft ? TextAlign.start : TextAlign.right,
              style: TextStyle(
                fontSize: 20,
                color: FlutterGameChallengeColors.textStroke,
              ),
            )
          ],
        ),
      ),
    );
  }
}
