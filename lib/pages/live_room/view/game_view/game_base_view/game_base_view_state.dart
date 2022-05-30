import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';

/// @description:
/// @author
/// @date: 2022-05-21 11:59:48
class GameBaseViewState {
  RxList dataOdds = [].obs;
  RxList dataResult = [].obs;
  RxMap websoketResult = {}.obs;
  var openBetOrPrize = 0.obs;
  var height = 0.pt.obs;
  var handerHeight = 120.pt.obs;
  var talbesIndex = 0;
  var token = "";
  // 倒计时
  var lastTime = 59.obs;
  var gameState = 1.obs;
  var gameResutlt = "".obs;
  GameBaseViewState() {}
}
