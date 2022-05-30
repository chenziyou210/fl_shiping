import 'dart:math';

import 'package:get/get.dart';

import 'my_mine_setting_state.dart';

/// @description:
/// @author
/// @date: 2022-05-25 11:30:29
class MyMineSettingLogic extends GetxController {
  final state = MyMineSettingState();

  setGames() async {
    List allResultList = [];
    //总投注人数
    int allUsers = 0;
    // 总金额
    double amontMoney = 1000000.0;
    // 总期数
    int time = 1440 ~/ 2;
    // 杀死率 最大 100
    int percent = 10;
    // 剩余结果
    double lastMoney = 0.0;
    // 用户总投注
    double userAmount = amontMoney;
    // 杀率控制次数
    int sha = 0;
    //  一天循环 1440 期结果
    for (var i = 0; i < time; i++) {
      //  每期参数人数
      Random allUsersRandom = Random();
      //  每期预设开奖结果
      Random startResultRandom = Random();
      int startResult = startResultRandom.nextInt(10);
      //  每期有1000人参加
      var allUserTemp = 1000;
      for (var user = 0; user < allUserTemp; user++) {
        Random usersMoneyRandom = Random();
        double preUserMoney = 0;
        // 每期每人投注多少钱？
        var userMoney = usersMoneyRandom.nextDouble() * 1000;
        // 每次投入每人投注结果
        Random partResultRandom = Random();
        int j = partResultRandom.nextInt(10);
        // 每次投注结果概率
        allResultList.add(j);
        preUserMoney += userMoney;
        //所有金额投注结果
        userAmount += userMoney;
      }
    }
    var list0 = allResultList.where((element) => element == 0).toList();
    state.value = userAmount ~/ 10000;
    state.users = list0.length;
    state.kongzhiTime = list0.length;
    update();
  }
}
