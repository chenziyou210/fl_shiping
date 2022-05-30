import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';

import 'my_mine_setting_logic.dart';
import 'my_mine_setting_state.dart';

/// @description:
/// @author
/// @date: 2022-05-25 11:30:29
class MyMineSettingPage extends StatelessWidget {
  final MyMineSettingLogic logic = Get.put(MyMineSettingLogic());
  final MyMineSettingState state = Get.find<MyMineSettingLogic>().state;

  MyMineSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: GetBuilder<MyMineSettingLogic>(
        builder: (c) {
          return InkWell(
              onTap: () {
                logic.setGames();
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "游戏总人数：1000人\n共期数：720期 \n每期金额：0~1000元  \n一天总金额:${state.value}万 \n总投注次数:${state.users}万",
                  style: TextStyle(color: Colors.white, fontSize: 18.pt),
                ),
              ));
        },
      ),
    ));
  }
}
