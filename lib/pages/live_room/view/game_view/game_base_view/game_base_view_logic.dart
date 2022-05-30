import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/pages/live_room/view/game_view/game_comment_view/game_base.dart';
import 'package:web_socket_channel/io.dart';

import '../game_network/GameNetWork.dart';
import 'game_base_view_state.dart';

/// @description:
/// @author
/// @date: 2022-05-21 11:59:48
class GameBaseViewLogic extends GetxController with Toast {
  final state = GameBaseViewState();
  IOWebSocketChannel? webSocketChannel;

  @override
  void onInit() {
    super.onInit();
    state.height.value = GameBase.height;
    requestOddsGame();
    requestResultGame(1);
    requestWebSowcket();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 玩法陪聊
  requestOddsGame() async {
    var values = await GameNetWork.getGame("odds", {
      "game_id": "1",
      "sign": "42d8812dcd7a038b1b4ae9c92471fcc1",
    });
    if (values is Map) {
      state.dataOdds.value = values['list'];
    } else {
      showToast(values['msg']);
    }
  }

  // 开奖记录
  requestResultGame(int page) async {
    var values = await GameNetWork.getGame("result", {
      "game_id": "1",
      "sign": "42d8812dcd7a038b1b4ae9c92471fcc1",
      "page": page,
      "page_size": "6"
    });
    if (values is Map) {
      state.dataResult.value = values['list'];
    } else {
      showToast(values['msg']);
    }
  }

  changeTabIndex(int index) {
    state.talbesIndex = index;
    update();
  }

// 如果失败了 5秒重连
  requestWebSowcket() async {
    await GameNetWork.initWebSoket("", "", "",
        (IOWebSocketChannel socketChannel, dynamic data) {
      if (webSocketChannel == null) {
        webSocketChannel = socketChannel;
      }
      // {"issue_id":"202205191064","state":1,"time":26,"result":""}
      state.websoketResult.value = jsonDecode(data);
      var tiem = state.websoketResult.value["time"];
      state.lastTime.value = tiem;
      var gameState = state.websoketResult.value["state"];
      // //  1 正常 ，2 封盘  3 开奖
      state.gameState.value = gameState;
    }, (d) {
      webSocketChannel = d;
      showToast("重新链接成功...");
      var times = Timer(Duration(seconds: 5), () {
        requestWebSowcket();
      });
      times.cancel();
    }, () {
      showToast("链接是失败");
    });
  }
}
