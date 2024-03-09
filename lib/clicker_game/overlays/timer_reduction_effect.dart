import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common.dart';

class TimerReductionEffect extends StatefulWidget {
  final String text;
  final VoidCallback onAnimationEnded;

  static const id = 'timer_reduction_overlay';

  const TimerReductionEffect({
    Key? key,
    required this.text,
    required this.onAnimationEnded,
  }) : super(key: key);

  @override
  _TimerReductionEffectState createState() => _TimerReductionEffectState();
}

class _TimerReductionEffectState extends State<TimerReductionEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Alignment> _translateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 2.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 2.0, end: 0.1),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _translateAnimation = Tween<Alignment>(
      begin: Alignment.center,
      end: Alignment.topCenter,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.addStatusListener(statusListener);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.3),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Align(
            alignment: _translateAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: context.textStyle(),
              ),
            ),
          );
        },
      ),
    );
  }

  void statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onAnimationEnded();
    }
  }
}
