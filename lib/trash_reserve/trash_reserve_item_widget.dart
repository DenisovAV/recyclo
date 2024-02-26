import 'package:flutter/material.dart';
import 'package:flutter_game_challenge/common/assets/colors.gen.dart';

class TrashReserveItemWidget extends StatefulWidget {
  const TrashReserveItemWidget({
    required this.color,
    required this.imagePath,
    required this.count,
    this.isRounded = false,
  });

  final bool isRounded;
  final Color color;
  final String imagePath;
  final int count;

  @override
  State<TrashReserveItemWidget> createState() => _TrashReserveItemWidgetState();
}

class _TrashReserveItemWidgetState extends State<TrashReserveItemWidget>
    with SingleTickerProviderStateMixin {
  late Tween<double> _resourceTween;
  late Animation<double> _animation;
  late AnimationController _resourcesController;

  @override
  void didUpdateWidget(TrashReserveItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.color != widget.count) {
      _resourceTween = Tween<double>(
        begin: oldWidget.count.toDouble(),
        end: widget.count.toDouble(),
      );

      _resourcesController.animateTo(0, duration: Duration.zero);

      _animation = _resourcesController.drive(_resourceTween);

      _resourcesController.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    _resourcesController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );
  }

  @override
  void dispose() {
    _resourcesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 64,
      decoration: BoxDecoration(
        color: widget.color,
        border: const Border(
          left: BorderSide(
            color: FlutterGameChallengeColors.textStroke,
            width: 2,
          ),
          bottom: BorderSide(
            color: FlutterGameChallengeColors.textStroke,
            width: 2,
          ),
          top: BorderSide(
            color: FlutterGameChallengeColors.textStroke,
            width: 2,
          ),
        ),
        borderRadius: widget.isRounded
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                topLeft: Radius.circular(12),
              )
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.imagePath,
              width: 32,
              height: 32,
            ),
            AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Text(
                    _animation.value.toInt().toString(),
                    style: const TextStyle(
                      color: FlutterGameChallengeColors.textStroke,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}