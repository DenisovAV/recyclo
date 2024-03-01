import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_challenge/common.dart';
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
            type: ItemType.organic,
            isRounded: true,
            count: state.model.organic,
          ),
          TrashReserveItemWidget(
            type: ItemType.plastic,
            count: state.model.plastic,
          ),
          TrashReserveItemWidget(
            type: ItemType.glass,
            count: state.model.glass,
          ),
          TrashReserveItemWidget(
            type: ItemType.paper,
            count: state.model.paper,
          ),
          TrashReserveItemWidget(
            type: ItemType.electronic,
            count: state.model.electronics,
          ),
        ],
      );
    });
  }
}
