import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/index.dart';
import 'package:recyclo/landing/widgets/artefacts_item.dart';
import 'package:recyclo/landing/widgets/download_from_stores_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxWidth < 800;

        return Scaffold(
          backgroundColor: FlutterGameChallengeColors.landingBackground,
          body: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child:
                    Assets.images.cloudsBackground.image(fit: BoxFit.fitHeight),
              ),
              ListView(
                controller: _controller,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const AboutUsItem(),
                  const SizedBox(
                    height: 50,
                  ),
                  const GamesItem(),
                  const SizedBox(
                    height: 50,
                  ),
                  const MechanicsWidget(),
                  const SizedBox(
                    height: 50,
                  ),
                  const ArtefactsItem(),
                  const SizedBox(
                    height: 50,
                  ),
                  const TeamWidget(),
                  const SizedBox(
                    height: 50,
                  ),
                  if (isSmallDevice) ...[
                    const DownloadFromStoresWidget(),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 100,
                child: LandingAppBar(
                  onTap: _onScrollingButtonTap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onScrollingButtonTap() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
