import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';

import '../../../page_config/page_config.dart';
import 'my_mine_info_state.dart';

/// @description:
/// @author
/// @date: 2022-05-25 12:15:59
class MyMineInfoLogic extends GetxController with Toast {
  final state = MyMineInfoState();

  //
  @override
  void onInit() {
    super.onInit();
  }

  gotoBack(BuildContext context) {
    Navigator.pop(context);
  }

  gotoEditUserInfo(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.mineEditInfo);
  }
}
