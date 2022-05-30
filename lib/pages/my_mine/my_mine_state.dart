import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// @description:
/// @author
/// @date: 2022-05-24 16:16:17
class MyMineState {
  late var gameGroup = ['收支明细', '游戏记录'];
  late var img = [AppImages.ic_balance, AppImages.ic_game_record];
  late var editGroup = ['编辑资料', '手机认证', '我的背包', '等级', '专属客服','退出登录'];
  late var data;
  late RefreshController refreshController;
  BuildContext? context;
  late var imgs = [
    AppImages.ic_edit_profile,
    AppImages.ic_phone_verify,
    AppImages.ic_bag,
    AppImages.ic_diamond,
    AppImages.ic_customer_service,
    AppImages.ic_customer_service,
  ];

  MyMineState() {
    data = null;
    refreshController = RefreshController();
  }
}

