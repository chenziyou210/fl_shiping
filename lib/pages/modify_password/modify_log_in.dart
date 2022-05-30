/*
 *  Copyright (C), 2015-2021
 *  FileName: modify_log_in
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'modify_password_base.dart';

class ModifyLogInPasswordPage extends StatefulWidget {
  @override
  createState()=> _ModifyLogInPasswordPageState();
}

class _ModifyLogInPasswordPageState extends ModifyPasswordBase<ModifyLogInPasswordPage> {
  final ModifyLogInPasswordLogic controller = ModifyLogInPasswordLogic();
  @override
  // TODO: implement text1
  String get text1 => "${intl.originalLogInPassword}";

  @override
  // TODO: implement text2
  String get text2 => "${intl.newLogInPassword}";

  @override
  // TODO: implement text3
  String get text3 => "${intl.confirmPassword}";

  @override
  // TODO: implement title
  String get title => "${intl.modifyLogInPassword}";
}

class ModifyLogInPasswordLogic extends ModifyPasswordBaseLogic{
  @override
  Future<bool> changePassword({String? oldPassword, required String newPassword,
    required String confirmPassword}) {
    // TODO: implement changePassword
    return HttpChannel.channel.modifyLogInPassword(newPassword: newPassword,
        confirmNewPassword: confirmPassword, oldPassword: oldPassword).then((value) {
          return value.finalize<WrapperModel>(
            wrapper: WrapperModel(),
            failure: (e)=> showToast(e)
          ).isSuccess;
    });
  }
}