/*
 *  Copyright (C), 2015-2021
 *  FileName: forget_password_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/7
 *  Description: 
 **/

import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/pages/register/register_new_logic.dart';

class ForgetPasswordLogic extends RegisterNewLogic {
  /// 忘记密码
  Future<bool> forgetPassword({required String phoneNumber, required String code,
    required String password, required String rePassword}) async{
    show();
    var result = await HttpChannel.channel.forgetPassword(account: phoneNumber, password: password,
        rePassword: rePassword, code: code).then((value) =>
      value.finalize<WrapperModel>(
        wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (_){
          dismiss();
        }
      ));
    return result.isSuccess;
  }
}
