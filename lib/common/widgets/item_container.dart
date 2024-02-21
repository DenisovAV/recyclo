import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/common.dart';

class ItemContainer extends StatelessWidget {
  const ItemContainer({
    required this.type,
    this.count = 0,
    super.key,
  });

  final ItemType type;
  final int count;

  static const containerSize = 66.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: type.color(),
        border: Border.all(
          color: FlutterGameChallengeColors.textStroke,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          type.image(),
          Text(
            count.toString(),
            style: const TextStyle(
              color: FlutterGameChallengeColors.textStroke,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
