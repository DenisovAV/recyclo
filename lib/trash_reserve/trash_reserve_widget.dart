import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/clicker_game/game_models/trash_type.dart';
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
            type: TrashType.organic,
            isRounded: true,
            count: state.model.organic,
          ),
          TrashReserveItemWidget(
            type: TrashType.plastic,
            count: state.model.plastic,
          ),
          TrashReserveItemWidget(
            type: TrashType.glass,
            count: state.model.glass,
          ),
          TrashReserveItemWidget(
            type: TrashType.paper,
            count: state.model.paper,
          ),
          TrashReserveItemWidget(
            type: TrashType.electric,
            count: state.model.electronics,
          ),
        ],
      );
    });
  }
}
