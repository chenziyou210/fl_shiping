/*
 *  Copyright (C), 2015-2021
 *  FileName: modify_pay_password
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'modify_password_base.dart';
import '../withdraw/setting_pay_password.dart';

class ModifyPayPasswordPage extends StatefulWidget {
  @override
  createState()=> _ModifyPayPasswordPageState();
}

class _ModifyPayPasswordPageState extends ModifyPasswordBase<ModifyPayPasswordPage> {
  final ModifyPayPasswordLogic controller = ModifyPayPasswordLogic();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (AppManager.getInstance<AppUser>().withdrawIsNull)
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        alertViewController(SettingPayPassword((value){
          popViewController();
          if (!value) popViewController();
        }, intl));
      });
  }

  @override
  // TODO: implement text1
  String get text1 => "${intl.originalPayPassword}";

  @override
  // TODO: implement text2
  String get text2 => "${intl.newPayPassword}";

  @override
  // TODO: implement text3
  String get text3 => "${intl.confirmPassword}";

  @override
  // TODO: implement title
  String get title => "${intl.modifyPaymentPassword}";
}

class ModifyPayPasswordLogic extends ModifyPasswordBaseLogic{
  @override
  Future<bool> changePassword({String? oldPassword, required String newPassword,
    required String confirmPassword}) {
    // TODO: implement changePassword
    return HttpChannel.channel.modifyWithdrawPassword(newPassword: newPassword,
        confirmNewPassword: confirmPassword, oldPassword: oldPassword).then((value) {
      return value.finalize<WrapperModel>(
          wrapper: WrapperModel(),
          failure: (e)=> showToast(e)
      ).isSuccess;
    });
  }
}