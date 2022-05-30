import 'package:get/get.dart';

import 'game_model.dart';

class JumpGameState {
  late int count;
  late var gameTabList = [
    GameTabItem("热门","HOT"),
    GameTabItem("真人","ZR"),
    GameTabItem("棋牌","QP"),
    GameTabItem("捕鱼","BY"),
    GameTabItem("电子","DZ"),
    GameTabItem("体育","TY"),
    GameTabItem("彩票","CP"),
  ].obs;

  JumpGameState() {
    count = 0;
  }
}

