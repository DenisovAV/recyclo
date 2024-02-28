import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/index.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterGameChallengeColors.landingBackground,
      appBar: LandingAppBar(),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Assets.images.cloudsBackground.image(fit: BoxFit.fitHeight),
          ),
          ListView(
            children: [
              SizedBox(
                height: 50,
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
            ],
          ),
        ],
      ),
    );
  }
}
