import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common/assets.dart';
import 'package:flutter_game_challenge/menu/widgets/clouds.dart';

class MainMenuBackground extends StatefulWidget {
  const MainMenuBackground({
    required this.isHighlighted,
    required this.isCompact,
    this.isShowingEarth = true,
    super.key,
  });

  factory MainMenuBackground.withoutEarth({
    bool isHighlighted = false,
    bool isCompact = false,
  }) =>
      MainMenuBackground(
        isHighlighted: isHighlighted,
        isCompact: isCompact,
        isShowingEarth: false,
      );

  final bool isHighlighted;
  final bool isCompact;
  final bool isShowingEarth;

  @override
  State<MainMenuBackground> createState() => _MainMenuBackgroundState();
}

class _MainMenuBackgroundState extends State<MainMenuBackground> with TickerProviderStateMixin {
  late final AnimationController _spinningController;
  late final AnimationController _highlightController;
  late final AnimationController _compactController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;
  late final Animation<Offset> _compactAnimation;

  static const _rotationDuration = Duration(seconds: 120);
  static const _highlightDuratioh = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    _spinningController = AnimationController(
      vsync: this,
      duration: _rotationDuration,
    )..repeat();

    _compactController = AnimationController(
      vsync: this,
      duration: _highlightDuratioh,
    );

    _highlightController = AnimationController(
      vsync: this,
      duration: _highlightDuratioh,
    );

    _compactAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.3),
    ).animate(_compactController);

    final highlightAnimationCurved = CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.6).animate(highlightAnimationCurved);

    _rotationAnimation = Tween<double>(begin: 0, end: 0.3).animate(highlightAnimationCurved);
  }

  @override
  void didUpdateWidget(MainMenuBackground oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isHighlighted != widget.isHighlighted) {
      widget.isHighlighted
          ? _highlightController.animateTo(1)
          : _highlightController.animateBack(0);
    }

    if (oldWidget.isCompact != widget.isCompact) {
      widget.isCompact ? _compactController.animateTo(1) : _compactController.animateBack(0);
    }
  }

  @override
  void dispose() {
    _spinningController.dispose();
    _highlightController.dispose();
    _compactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Clouds(
            highlightAnimation: _scaleAnimation,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Clouds(
              highlightAnimation: _scaleAnimation,
            ),
          ),
        ),
        if(widget.isShowingEarth)
        SlideTransition(
          position: _compactAnimation,
          child: Transform.translate(
            offset: const Offset(0, 100),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 320,
                height: 320,
                child: RotationTransition(
                  turns: _rotationAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: RotationTransition(
                      turns: _spinningController,
                      child: Assets.images.earth.image(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
