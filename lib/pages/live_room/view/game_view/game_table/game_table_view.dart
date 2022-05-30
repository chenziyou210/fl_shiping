import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/pages/live_room/view/game_view/game_comment_view/game_base.dart';

import 'game_table_logic.dart';
import 'game_table_state.dart';

/// @description: 游戏选择
/// @author   austin
/// @date: 2022-05-20 14:00:09
class GameTablePage extends StatelessWidget {
  final GameTableLogic logic = Get.put(GameTableLogic());
  final GameTableState state = Get.find<GameTableLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<GameTableLogic>(
        builder: (_) {
          return body();
        },
      ),
    );
  }

  Widget body() {
    return Obx(() {
      return Container(
        height: state.hight.value,
        color: Colors.transparent,
        child: Stack(
          children: [
            // 背景
            Opacity(
              opacity: 0.9,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                ),
              ),
            ),
            Positioned(
              top: 50.pt,
              left: 0.pt,
              right: 0.pt,
              child: contentGrid(),
            ),
          ],
        ),
      );
    });
  }

  Widget contentGrid() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 5,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        return tableItem(context, 1);
      },
    );
  }

  Widget tableItem(BuildContext context, dynamic data) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        logic.showGameK3(context, GameBase.height);
      },
      child: SizedBox(
        child: Column(
          children: [
            Image.asset(
              AppImages.givingCoins,
              width: 75.pt,
              height: 75.pt,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
