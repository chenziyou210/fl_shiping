import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/http/http_channel.dart';

import 'my_fans_state.dart';

/// @description:
/// @author
/// @date: 2022-05-25 18:52:49
class MyFansLogic extends GetxController {
  final state = MyFansState();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    state.refreshController.requestRefresh();
  }

  requestPage(int page) {
    HttpChannel.channel.favoritePaging(1).then((value) {
      state.listData = [];
      var data = value.data['data']['data'];
      state.listData = data;
      update();
      state.refreshController.refreshCompleted();
      state.refreshController.loadComplete();
    });
  }

  void setFollowOrFans(bool value) {
    state.folowOrFans = value;
    update();
    state.pageController.jumpToPage(value == true ? 0 : 1);
  }
}
