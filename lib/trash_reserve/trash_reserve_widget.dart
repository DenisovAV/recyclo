import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/common/assets.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_cubit.dart';
import 'package:flutter_game_challenge/trash_reserve/cubit/trash_reserve_state.dart';
import 'package:flutter_game_challenge/trash_reserve/trash_reserve_item_widget.dart';

class TrashReserveWidget extends StatelessWidget {
  const TrashReserveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrashReserveCubit, TrashReserveState>(
        builder: (context, state) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TrashReserveItemWidget(
            isRounded: true,
            color: FlutterGameChallengeColors.categoryGreen,
            imagePath: Assets.images.organic.path,
            count: state.model.organic,
          ),
          TrashReserveItemWidget(
            color: FlutterGameChallengeColors.categoryViolet,
            imagePath: Assets.images.plastic.path,
            count: state.model.plastic,
          ),
          TrashReserveItemWidget(
            color: FlutterGameChallengeColors.categoryOrange,
            imagePath: Assets.images.glass.path,
            count: state.model.glass,
          ),
          TrashReserveItemWidget(
            color: FlutterGameChallengeColors.categoryYellow,
            imagePath: Assets.images.paper.path,
            count: state.model.paper,
          ),
          TrashReserveItemWidget(
            color: FlutterGameChallengeColors.categoryPink,
            imagePath: Assets.images.energy.path,
            count: state.model.electronics,
          ),
        ],
      );
    });
  }
}
