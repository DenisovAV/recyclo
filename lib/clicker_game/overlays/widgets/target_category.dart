import 'package:flutter/material.dart';

import '../../game_models/trash_type.dart';

class TargetCategories extends StatelessWidget {
  const TargetCategories({
    required this.itemIndex,
    required this.trashType,
    super.key,
  });

  final int itemIndex;
  final TrashType trashType;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      scale: 1 - ((itemIndex * 3) / 100),
      child: SizedBox.square(
        dimension: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trashType.color,
            border: Border.all(
              color: const Color(0xFF4D3356),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Image.asset(
                trashType.iconPath,
              ),
            ),
          ),
        ),
      ),
    );
  }
}