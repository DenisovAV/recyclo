import 'package:flutter/material.dart';
import 'package:recyclo/clicker_game/game_models/trash_type.dart';

class TargetCategories extends StatefulWidget {
  const TargetCategories({
    required this.trashType,
    this.animate = true,
    Key? key,
  }) : super(key: key);

  final TrashType trashType;
  final bool animate;

  @override
  _TargetCategoriesState createState() => _TargetCategoriesState();
}

class _TargetCategoriesState extends State<TargetCategories>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.trashType.color,
              border: Border.all(
                color: const Color(0xFF4D3356),
                width: 2,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(_glowAnimation.value),
                  blurRadius: 8,
                  spreadRadius: _glowAnimation.value * 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Image.asset(
                  widget.trashType.iconPath,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
