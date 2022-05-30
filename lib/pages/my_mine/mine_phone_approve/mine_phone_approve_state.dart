import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MinePhoneApproveState {
  late TextEditingController phoneTEC;
  late TextEditingController codeTEC;
  var codeText = '点击发送'.obs;
  var codeStatus = true.obs;
  late int codeId;
  late BuildContext context;

  MinePhoneApproveState() {
    phoneTEC = TextEditingController();
    codeTEC = TextEditingController();
  }

}
