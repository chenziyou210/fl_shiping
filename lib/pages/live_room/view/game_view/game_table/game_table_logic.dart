import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/pages/live_room/view/game_view/game_base_view/game_base_view_view.dart';

import '../../../../../common/app_common_widget.dart';
import '../game_base_view/game_base_view_logic.dart';
import '../game_network/GameNetWork.dart';
import 'game_table_state.dart';

/// @description:
/// @author
/// @date: 2022-05-20 14:00:09
class GameTableLogic extends GetxController with Toast {
  final state = GameTableState();

  @override
  void onInit() {
    super.onInit();
    requestGame();
  }

  showGameK3(BuildContext context, double value) {
    if (state.data.isEmpty) {
      showToast("数据加载中..");
      requestGame();
      return;
    }

    customShowModalBottomSheet(
            context: context,
            builder: (_) {
              return GameBaseViewPage(
                state.data[0]["description"],
                gameChangeSize: (bool openOrColose) {},
              );
            },
            fixedOffsetHeight: value,
            isScrollControlled: true,
            barrierColor: Colors.transparent,
            backgroundColor: Colors.transparent)
        .then((value) {
      GameBaseViewLogic logic = Get.put(GameBaseViewLogic());
      logic.onDelete();
      print("object");
    });
  }

  requestGame() async {
    var data = await GameNetWork.getGame("list", {});
    if (data is Map) {
      List list = data['list'];
      if (list.isNotEmpty) {
        state.data = list;
        update();
      }
    } else {
      showToast("Error");
    }
  }
}
