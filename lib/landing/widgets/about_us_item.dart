import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/widgets/landing_item.dart';

class AboutUsItem extends StatelessWidget {
  const AboutUsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 800;

      return LandingItem(
        color: FlutterGameChallengeColors.aboutAppBackground,
        child: Padding(
          padding: EdgeInsets.all(isSmallDevice ? 10 : 50),
          child: Column(
            children: [
              Center(
                child: Text(
                  l10n.aboutAppRecycle,
                  style: TextStyle(
                    fontSize: 48,
                    color: FlutterGameChallengeColors.textStroke,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      l10n.aboutAppRecycleContentText,
                      style: TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                  ),
                  if (!isSmallDevice) ...[
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(child: Assets.images.logoDescription.image(fit: BoxFit.fill)),
                  ]
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
