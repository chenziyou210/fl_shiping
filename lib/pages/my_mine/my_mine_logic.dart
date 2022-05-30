import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../../common/app_common_widget.dart';
import '../../http/http_channel.dart';
import '../../manager/app_manager.dart';
import '../../page_config/page_config.dart';
import 'my_mine_state.dart';

/// @description:
/// @author
/// @date: 2022-05-24 16:16:17
class MyMineLogic extends GetxController with Toast {
  final state = MyMineState();
  @override
  void onReady() {
    super.onReady();
    state.refreshController.requestRefresh();
  }

  requestUserInfo() {
    HttpChannel.channel.userInfo().then((value) {
      if (value.isSuccess) {
        state.data = value.data['data'];
        update();
      } else {
        showToast(value.err);
      }
      state.refreshController.refreshCompleted();
    });
  }

  gotoSetting(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mineSetting);
  }

  gotoUserInfo(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mineInfo);
  }

  gotoFollowAndFans(BuildContext context, int type) {
    // Map map = {"type": type};
    //, arguments: map
    Navigator.pushNamed(context, AppRoutes.mineFloowAndFans);
  }

  // 暂时添加
  mineItemEvent(String itemTitle, BuildContext context) async {
    showToast('点击了$itemTitle');
    switch (itemTitle) {
      case '编辑资料':
        Navigator.of(context).pushNamed(AppRoutes.mineEditInfo);
        break;
      case '我的背包':
        Navigator.of(context).pushNamed(AppRoutes.mineBackpackPage);
        break;
      case '手机认证':
        Navigator.of(context).pushNamed(AppRoutes.minePhoneApprovePage);
        break;
      case '退出登录':
        try {
          // true: 是否解除deviceToken绑定。
          EMClient.getInstance.logout(true);
        } on EMError catch (e) {
          print('操作失败，原因是: $e');
        }
        HttpChannel.channel.logOut();
        EventBus.instance.removeAllListener();
        AppManager.getInstance<AppUser>().logOut();
        Navigator.of(context).pushNamed(AppRoutes.logInNew);
        break;
    }
  }



}
