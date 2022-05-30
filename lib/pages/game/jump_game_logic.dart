import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_images/app_images.dart';
import 'game_model.dart';
import 'jump_game_state.dart';

class JumpGameLogic extends GetxController {
  final JumpGameState state = JumpGameState();

  ///自增
  void increase() {
    state.count = ++state.count;
    update();
  }

  void getGames() {
    var gameList = [
      GameItem("AG真人",AppImages.imgPlaceHolder, "1",true,"https://www.google.com","ZR"),
      GameItem("凤凰真人",AppImages.imgPlaceHolder, "2",true,"https://www.google.com","ZR"),
      GameItem("AG棋牌",AppImages.imgPlaceHolder, "3",true,"https://www.google.com","QP"),
      GameItem("凤凰棋牌",AppImages.imgPlaceHolder, "4",true,"https://www.google.com","QP"),
      GameItem("凤凰捕鱼",AppImages.imgPlaceHolder, "5",true,"https://www.google.com","BY"),
      GameItem("高汤捕鱼",AppImages.imgPlaceHolder, "6",true,"https://www.google.com","BY"),
      GameItem("百人捕鱼",AppImages.imgPlaceHolder, "7",true,"https://www.google.com","BY"),
      GameItem("百万金币捕鱼",AppImages.imgPlaceHolder, "8",true,"https://www.google.com","BY"),
    ];
    for (var tab in state.gameTabList.value) {
      if(tab.gameType == "HOT"){
        tab.listData= gameList.where((element) => (element.isHot??false)).toList();
      }else{
        tab.listData= gameList.where((element) => element.gameType == tab.gameType).toList();
      }
    }
    update();
  }

  void addTestGame(String? gameType) {
    state.gameTabList.value.where((element) => element.gameType==gameType).first.listData?.add(
        GameItem("TestGame",AppImages.imgPlaceHolder, "11",false,"https://www.google.com",gameType)
    );
    update();
  }
}
