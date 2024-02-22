import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common/assets.dart';
import 'package:video_player/video_player.dart';

class MainMenuBackground extends StatefulWidget {
  const MainMenuBackground({
    required this.isHighlighted,
    required this.isCompact,
    super.key,
  });

  final bool isHighlighted;
  final bool isCompact;

  @override
  State<MainMenuBackground> createState() => _MainMenuBackgroundState();
}

class _MainMenuBackgroundState extends State<MainMenuBackground>
    with TickerProviderStateMixin {
  late final AnimationController _highlightController;
  late final AnimationController _compactController;
  late final VideoPlayerController _playerController;

  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<Offset> _compactAnimation;

  static const _highlightDuratioh = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    _playerController = VideoPlayerController.asset(Assets.images.earth)
      ..setLooping(true)
      ..play()
      ..initialize().then((_) {
        setState(() {});
      });
    ;

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

    _scaleAnimation =
        Tween<double>(begin: 1, end: 1.6).animate(highlightAnimationCurved);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.3),
    ).animate(highlightAnimationCurved);
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
      widget.isCompact
          ? _compactController.animateTo(1)
          : _compactController.animateBack(0);
    }
  }

  @override
  void dispose() {
    _playerController.dispose();
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
          child: _Clouds(
            highlightAnimation: _scaleAnimation,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: _Clouds(
              highlightAnimation: _scaleAnimation,
            ),
          ),
        ),
        SlideTransition(
          position: _compactAnimation,
          child: Transform.translate(
            offset: const Offset(0, 100),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 340,
                height: 340,
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: _playerController.value.isInitialized
                        ? Stack(
                            children: [
                              Assets.images.earthHalo.image(
                                color: FlutterGameChallengeColors.earthGlow,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18),
                                child: AspectRatio(
                                  aspectRatio:
                                      _playerController.value.aspectRatio,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(170),
                                    child: VideoPlayer(_playerController),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
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

class _Clouds extends StatelessWidget {
  const _Clouds({
    required this.highlightAnimation,
  });

  final Animation<double> highlightAnimation;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.4,
      child: ScaleTransition(
        scale: highlightAnimation,
        child: Assets.images.clouds.image(),
      ),
    );
  }
}
