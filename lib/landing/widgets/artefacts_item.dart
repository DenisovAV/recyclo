import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/common/artefact_constance.dart';
import 'package:flutter_game_challenge/landing/widgets/brand_text.dart';
import 'package:flutter_game_challenge/landing/widgets/landing_item.dart';

class ArtefactsItem extends StatefulWidget {
  const ArtefactsItem({super.key});

  @override
  State<ArtefactsItem> createState() => _ArtefactsItemState();
}

class _ArtefactsItemState extends State<ArtefactsItem> {
  late final PageController _imagesController;
  late final PageController _descriptionsController;

  @override
  void initState() {
    _imagesController = PageController();
    _descriptionsController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _imagesController.dispose();
    _descriptionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 850;

      if (isSmallDevice) {
        return LandingItem(
          color: FlutterGameChallengeColors.teamBackground,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Center(
                  child: BrandText(
                    l10n.artefacts,
                    style: TextStyle(
                      fontSize: 36,
                      color: FlutterGameChallengeColors.textStroke,
                    ),
                  ),
                ),
                Column(
                  children: [
                    _ImagePageView(
                      controller: _imagesController,
                      images: artefacts.map((e) => e.image).toList(),
                      onPageChange: _handleImagesPageViewChange,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    _TextPageView(
                      controller: _descriptionsController,
                      onPageChange: _handleDescriptionPageViewChange,
                      items: artefacts,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }

      return LandingItem(
        color: FlutterGameChallengeColors.teamBackground,
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              Center(
                child: BrandText(
                  l10n.artefacts,
                  style: TextStyle(
                    fontSize: 36,
                    color: FlutterGameChallengeColors.textStroke,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImagePageView(
                    controller: _imagesController,
                    images: artefacts.map((e) => e.image).toList(),
                    onPageChange: _handleImagesPageViewChange,
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  _TextPageView(
                    controller: _descriptionsController,
                    onPageChange: _handleDescriptionPageViewChange,
                    items: artefacts,
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  void _handleImagesPageViewChange(int index) {
    _descriptionsController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _handleDescriptionPageViewChange(int index) {
    _imagesController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}

class _ImagePageView extends StatelessWidget {
  final PageController controller;
  final List<String> images;
  final ValueChanged<int> onPageChange;

  const _ImagePageView({
    required this.controller,
    required this.images,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isSmallDevice = constraints.maxWidth < 850;

      return Row(
        children: [
          SizedBox(
            height: 250,
            width: isSmallDevice ? 25 : 40,
            child: Material(
              color: FlutterGameChallengeColors.textStroke,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: InkWell(
                onTap: () => controller.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                ),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 32,
                    color: FlutterGameChallengeColors.teamBackground,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: isSmallDevice ? 300 : 350,
            width: isSmallDevice ? 300 : 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                width: 4,
                color: FlutterGameChallengeColors.textStroke,
              ),
            ),
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: onPageChange,
              controller: controller,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 250,
            width: isSmallDevice ? 25 : 40,
            child: Material(
              color: FlutterGameChallengeColors.textStroke,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: InkWell(
                onTap: () => controller.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                ),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 32,
                    color: FlutterGameChallengeColors.teamBackground,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _TextPageView extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChange;
  final List<ArtefactDescriptions> items;

  const _TextPageView({
    required this.controller,
    required this.onPageChange,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 1000,
          ),
          child: PageView.builder(
            itemCount: artefacts.length,
            controller: controller,
            onPageChanged: onPageChange,
            itemBuilder: (context, index) {
              final item = items[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BrandText(
                      item.title,
                      style: TextStyle(
                        fontSize: 48,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    BrandText(
                      artefacts[index].details,
                      style: TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    BrandText(
                      l10n.description,
                      style: TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 3,
                      color: FlutterGameChallengeColors.textStroke,
                      width: double.maxFinite,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    BrandText(
                      item.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    BrandText(
                      l10n.reality,
                      style: TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 3,
                      color: FlutterGameChallengeColors.textStroke,
                      width: double.maxFinite,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    BrandText(
                      item.reality,
                      style: TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
