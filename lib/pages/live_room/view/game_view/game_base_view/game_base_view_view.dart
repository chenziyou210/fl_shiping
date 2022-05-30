import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';

import '../game_comment_view/game_base.dart';
import '../game_comment_view/game_bet_view.dart';
import '../game_comment_view/game_last_time_view.dart';
import '../game_comment_view/game_title_view.dart';
import '../game_comment_view/k3_game_view.dart';
import 'game_base_view_logic.dart';
import 'game_base_view_state.dart';

/// @description:
/// @author
/// @date: 2022-05-21 11:59:48
class GameBaseViewPage extends StatelessWidget {
  final GameBaseViewLogic logic = Get.put(GameBaseViewLogic());
  final GameBaseViewState state = Get.find<GameBaseViewLogic>().state;
  final String data;
  final GameChangeSize gameChangeSize;
  GameBaseViewPage(this.data, {Key? key, required this.gameChangeSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: body(context),
    );
  }

  Widget body(BuildContext c) {
    return Obx(() {
      return SizedBox(
        height: state.height.value,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(c).pop();
                Get.back();
              },
              child: SizedBox(
                height: state.handerHeight.value,
                width: double.infinity,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // 背景
                  Opacity(
                    opacity: 0.5,
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
                  // 顶部
                  contentView(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget contentView() {
    return Obx(() {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ttiles(state.websoketResult),
            Expanded(
                child: Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.pt),
                  child: Column(
                    children: [
                      _time(),
                      Expanded(
                        child: K3GameView(state.dataOdds),
                      ),
                      GameBetView(state.dataOdds),
                    ],
                  ),
                ),
              ],
            )),
          ],
        ),
      );
    });
  }

  Widget _ttiles(RxMap websoketResult) {
    Text(
      "${state.websoketResult}",
    );
    return GameTitleView(
      state.websoketResult,
      data,
      state.dataResult,
      state.handerHeight,
      init: () {
        logic.requestResultGame(1);
      },
      //投注记录回调
      gameOpen: (openColose, requestIndex) {
        if (openColose) {
          state.handerHeight.value = 0.pt;
          logic.requestResultGame(requestIndex);
        } else {
          state.handerHeight.value = 120.pt;
        }
        gameChangeSize.call(openColose);
      },
      //开奖记录回调
      gameRecord: (openColose, requestIndex) {
        if (openColose) {
          state.handerHeight.value = 0.pt;
          logic.requestResultGame(requestIndex);
        } else {
          state.handerHeight.value = 120.pt;
        }
        gameChangeSize.call(openColose);
      },
    );
  }

  Widget _time() {
    return GameLastTimeView(
        state.websoketResult, state.dataResult, state.handerHeight);
  }
}
