import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/common/assets.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_state.dart';

class TrashReserveWidget extends StatelessWidget {
  const TrashReserveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrashReserveCubit, TrashReserveState>(
        builder: (context, state) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TrashReserveItemWidget(
            isRounded: true,
            color: FlutterGameChallengeColors.categoryGreen,
            imagePath: Assets.images.organic.path,
            count: state.model.organic,
          ),
          _TrashReserveItemWidget(
            color: FlutterGameChallengeColors.categoryViolet,
            imagePath: Assets.images.plastic.path,
            count: state.model.plastic,
          ),
          _TrashReserveItemWidget(
            color: FlutterGameChallengeColors.categoryOrange,
            imagePath: Assets.images.glass.path,
            count: state.model.glass,
          ),
          _TrashReserveItemWidget(
            color: FlutterGameChallengeColors.categoryYellow,
            imagePath: Assets.images.paper.path,
            count: state.model.paper,
          ),
          _TrashReserveItemWidget(
            color: FlutterGameChallengeColors.categoryPink,
            imagePath: Assets.images.energy.path,
            count: state.model.electronics,
          ),
        ],
      );
    });
  }
}

class _TrashReserveItemWidget extends StatelessWidget {
  const _TrashReserveItemWidget({
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
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 74,
      decoration: BoxDecoration(
        color: color,
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
        borderRadius: isRounded
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(12),
              )
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 32,
              height: 32,
            ),
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
      ),
    );
  }
}
