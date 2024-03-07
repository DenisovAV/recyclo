import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/index.dart';
import 'package:flutter_game_challenge/landing/widgets/artefacts_item.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterGameChallengeColors.landingBackground,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Assets.images.cloudsBackground.image(fit: BoxFit.fitHeight),
          ),
          ListView(
            children: [
              SizedBox(
                height: 150,
              ),
              AboutUsItem(),
              SizedBox(
                height: 50,
              ),
              GamesItem(),
              SizedBox(
                height: 50,
              ),
              MechanicsWidget(),
              SizedBox(
                height: 50,
              ),
              ArtefactsItem(),
              SizedBox(
                height: 50,
              ),
              TeamItem(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: LandingAppBar(),
          ),
        ],
      ),
    );
  }
}
