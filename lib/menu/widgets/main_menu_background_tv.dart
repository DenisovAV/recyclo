import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';
import 'package:video_player/video_player.dart';

class MainMenuBackgroundTv extends StatefulWidget {
  const MainMenuBackgroundTv({
    required this.isHighlighted,
    required this.isCompact,
    super.key,
  });

  final bool isHighlighted;
  final bool isCompact;

  @override
  State<MainMenuBackgroundTv> createState() => _MainMenuBackgroundTvState();
}

class _MainMenuBackgroundTvState extends State<MainMenuBackgroundTv>
    with TickerProviderStateMixin {
  late final AnimationController _highlightController;
  late final AnimationController _compactController;
  late final VideoPlayerController _playerController;
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

    _playerController.addListener(_onPlayerStopped);

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
  }

  void _onPlayerStopped() {
    if (!_playerController.value.isPlaying) {
      _playerController.play();
    }
  }

  @override
  void didUpdateWidget(MainMenuBackgroundTv oldWidget) {
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
    _playerController
      ..removeListener(_onPlayerStopped)
      ..dispose();
    _highlightController.dispose();
    _compactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Assets.images.tvBackground.image(
          width: double.infinity,
          height: double.infinity,
        ),
        SlideTransition(
          position: _compactAnimation,
          child: Transform.translate(
            offset: const Offset(0, 100),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(80, 80),
                child: SizedBox(
                  width: 340,
                  height: 340,
                  child: Stack(
                    children: [
                      Assets.images.earthHalo.image(
                        color: FlutterGameChallengeColors.earthGlow,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: AspectRatio(
                          aspectRatio: _playerController.value.aspectRatio,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(170),
                            child: Semantics(
                              label: context.l10n.earthAnimation,
                              child: VideoPlayer(_playerController),
                            ),
                          ),
                        ),
                      ),
                    ],
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
