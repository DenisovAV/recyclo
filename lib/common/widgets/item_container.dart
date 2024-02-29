import 'package:flutter/widgets.dart';
import 'package:flutter_game_challenge/common.dart';

class ItemContainer extends StatelessWidget {
  const ItemContainer({
    required this.type,
    this.count = 0,
    this.scale = 1.0,
    super.key,
  });

  final ItemType type;
  final int count;
  final double scale;

  static const containerSize = 66.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize * scale,
      height: containerSize * scale,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: type.color(),
        border: Border.all(
          color: FlutterGameChallengeColors.textStroke,
          width: 2 * scale,
        ),
        borderRadius: BorderRadius.circular(18 * scale),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          type.image(
            size: Size.square(32 * scale),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              color: FlutterGameChallengeColors.textStroke,
              fontSize: 18 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
