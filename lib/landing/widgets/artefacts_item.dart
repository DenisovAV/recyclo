import 'package:flutter/material.dart';
import 'package:recyclo/artifacts/wallet/service/artifacts_wallet.dart';
import 'package:recyclo/artifacts/wallet/wallet_pass.dart';
import 'package:recyclo/common.dart';
import 'package:recyclo/landing/widgets/brand_text.dart';
import 'package:recyclo/landing/widgets/landing_item.dart';

final _artefacts = androidWallet.values.toList();

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxWidth < 1150;

        if (isSmallDevice) {
          return LandingItem(
            color: FlutterGameChallengeColors.teamBackground,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Center(
                    child: BrandText(
                      l10n.artefacts,
                      style: const TextStyle(
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
                      const SizedBox(
                        width: 50,
                      ),
                      _TextPageView(
                        controller: _descriptionsController,
                        onPageChange: _handleDescriptionPageViewChange,
                        items: _artefacts,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return LandingItem(
          color: FlutterGameChallengeColors.teamBackground,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Center(
                  child: BrandText(
                    l10n.artefacts,
                    style: const TextStyle(
                      fontSize: 36,
                      color: FlutterGameChallengeColors.textStroke,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    _TextPageView(
                      controller: _descriptionsController,
                      onPageChange: _handleDescriptionPageViewChange,
                      items: _artefacts,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleImagesPageViewChange(int index) {
    setState(() {
      activeIndex = index;
    });
    _descriptionsController.animateToPage(
      activeIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _handleDescriptionPageViewChange(int index) {
    setState(() {
      activeIndex = index;
    });
    _imagesController.animateToPage(
      activeIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}

class _ImagePageView extends StatelessWidget {

  const _ImagePageView({
    required this.controller,
    required this.images,
    required this.onPageChange,
  });
  final PageController controller;
  final List<String> images;
  final ValueChanged<int> onPageChange;

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
                borderRadius: const BorderRadius.only(
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: const Center(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          width: 4,
                          color: FlutterGameChallengeColors.textStroke,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(14)),
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
                borderRadius: const BorderRadius.only(
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
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: const Center(
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
          constraints: const BoxConstraints(
            maxWidth: 430,
          ),
          child: Row(
            children: [
              SizedBox(
                height: 250,
                width: 40,
                child: Material(
                  color: FlutterGameChallengeColors.textStroke,
                  borderRadius: const BorderRadius.only(
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
                      child: const Center(
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
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          width: 4,
                          color: FlutterGameChallengeColors.textStroke,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(14)),
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
                  borderRadius: const BorderRadius.only(
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
                      child: const Center(
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
    },);
  }

  void _onNextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _onPreviousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}

class _DottedWidget extends StatelessWidget {

  const _DottedWidget({
    required this.activeIndex,
    required this.itemCount,
  });
  final int activeIndex;
  final int itemCount;

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
              },),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {

  const _Dot({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive
            ? FlutterGameChallengeColors.textStroke
            : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          width: 2,
          color: FlutterGameChallengeColors.textStroke,
        ),
      ),
    );
  }
}

class _TextPageView extends StatelessWidget {

  const _TextPageView({
    required this.controller,
    required this.onPageChange,
    required this.items,
  });
  final PageController controller;
  final ValueChanged<int> onPageChange;
  final List<WalletPass> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
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
                      style: const TextStyle(
                        fontSize: 48,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BrandText(
                      item.details,
                      style: const TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    BrandText(
                      l10n.description,
                      style: const TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 3,
                      color: FlutterGameChallengeColors.textStroke,
                      width: double.maxFinite,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BrandText(
                      item.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    BrandText(
                      l10n.reality,
                      style: const TextStyle(
                        fontSize: 20,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 3,
                      color: FlutterGameChallengeColors.textStroke,
                      width: double.maxFinite,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BrandText(
                      item.reality,
                      style: const TextStyle(
                        fontSize: 16,
                        color: FlutterGameChallengeColors.textStroke,
                      ),
                    ),
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
