import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/artifacts/wallet/service/artifacts_wallet.dart';
import 'package:flutter_game_challenge/artifacts/wallet/wallet_pass.dart';
import 'package:flutter_game_challenge/common.dart';
import 'package:flutter_game_challenge/landing/widgets/brand_text.dart';
import 'package:flutter_game_challenge/landing/widgets/landing_item.dart';

final _artefacts = wallet.values.toList();

class ArtefactsItem extends StatefulWidget {
  const ArtefactsItem({super.key});

  @override
  State<ArtefactsItem> createState() => _ArtefactsItemState();
}

class _ArtefactsItemState extends State<ArtefactsItem> {
  late final PageController _imagesController;
  late final PageController _descriptionsController;

  late int activeIndex;

  @override
  void initState() {
    activeIndex = 0;
    _imagesController = PageController(initialPage: activeIndex);
    _descriptionsController = PageController(initialPage: activeIndex);
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
      final isSmallDevice = constraints.maxWidth < 1150;

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
                      images: _artefacts.map((e) => e.image).toList(),
                      onPageChange: _handleImagesPageViewChange,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _DottedWidget(
                      activeIndex: activeIndex,
                      itemCount: _artefacts.length,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    _TextPageView(
                      controller: _descriptionsController,
                      onPageChange: _handleDescriptionPageViewChange,
                      items: _artefacts,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _ImagePageView(
                        controller: _imagesController,
                        images: _artefacts.map((e) => e.image).toList(),
                        onPageChange: _handleImagesPageViewChange,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _DottedWidget(
                        activeIndex: activeIndex,
                        itemCount: _artefacts.length,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  _TextPageView(
                    controller: _descriptionsController,
                    onPageChange: _handleDescriptionPageViewChange,
                    items: _artefacts,
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
    setState(() {
      activeIndex = index;
    });
    _descriptionsController.animateToPage(
      activeIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _handleDescriptionPageViewChange(int index) {
    setState(() {
      activeIndex = index;
    });
    _imagesController.animateToPage(
      activeIndex,
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

      if (isSmallDevice) {
        return Row(
          children: [
            SizedBox(
              width: 50,
              height: 180,
              child: Material(
                color: FlutterGameChallengeColors.textStroke,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Semantics(
                  label: context.l10n.backButtonLabel,
                  button: true,
                  enabled: true,
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: _onPreviousPage,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
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
            ),
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                height: 250,
                child: PageView.builder(
                  itemCount: images.length,
                  onPageChanged: onPageChange,
                  controller: controller,
                  itemBuilder: (context, index) {
                    final image = images[index];

                    return Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          width: 4,
                          color: FlutterGameChallengeColors.textStroke,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 50,
              height: 180,
              child: Material(
                color: FlutterGameChallengeColors.textStroke,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Semantics(
                  label: context.l10n.nextButtonLabel,
                  button: true,
                  enabled: true,
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: _onNextPage,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
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
            ),
          ],
        );
      }

      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 430,
          ),
          child: Row(
            children: [
              SizedBox(
                height: 250,
                width: 40,
                child: Material(
                  color: FlutterGameChallengeColors.textStroke,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Semantics(
                    label: context.l10n.backButtonLabel,
                    button: true,
                    enabled: true,
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: _onPreviousPage,
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
              ),
              SizedBox(
                height: 350,
                width: 350,
                child: PageView.builder(
                  itemCount: images.length,
                  onPageChanged: onPageChange,
                  controller: controller,
                  itemBuilder: (context, index) {
                    final image = images[index];

                    return Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          width: 4,
                          color: FlutterGameChallengeColors.textStroke,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 250,
                width: 40,
                child: Material(
                  color: FlutterGameChallengeColors.textStroke,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Semantics(
                     label: context.l10n.nextButtonLabel,
                    button: true,
                    enabled: true,
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: _onNextPage,
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
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onNextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _onPreviousPage() {
    controller.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}

class _DottedWidget extends StatelessWidget {
  final int activeIndex;
  final int itemCount;

  const _DottedWidget({
    required this.activeIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 10,
      child: Center(
        child: SizedBox(
          width: 120,
          child: ListView.builder(
              itemCount: itemCount,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: _Dot(isActive: index == activeIndex),
                );
              }),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive
            ? FlutterGameChallengeColors.textStroke
            : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          width: 2,
          color: FlutterGameChallengeColors.textStroke,
        ),
      ),
    );
  }
}

class _TextPageView extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChange;
  final List<WalletPass> items;

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
            itemCount: items.length,
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
                      item.details,
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
