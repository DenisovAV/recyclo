import 'package:flutter/material.dart';
import 'package:recyclo/common.dart';

class TrashReserveItemWidget extends StatefulWidget {
  const TrashReserveItemWidget({
    required this.type,
    required this.count,
    this.isRounded = false,
  });

  final ItemType type;
  final bool isRounded;
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

    if (widget.count < oldWidget.count) {
      _resourceTween = Tween<double>(
        begin: oldWidget.count.toDouble(),
        end: widget.count.toDouble(),
      );

      _resourcesController.animateTo(0, duration: Duration.zero);

      _animation = _resourcesController.drive(_resourceTween);

      _resourcesController.forward();
    } else {
      _animation = Tween<double>(
        begin: widget.count.toDouble(),
        end: widget.count.toDouble(),
      ).animate(_resourcesController);
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

    _animation = Tween<double>(
      begin: widget.count.toDouble(),
      end: widget.count.toDouble(),
    ).animate(_resourcesController);
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
        color: widget.type.color,
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
              widget.type.iconPath,
              width: 24,
              height: 24,
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
