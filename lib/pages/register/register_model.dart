/*
 *  Copyright (C), 2015-2021
 *  FileName: register_model
 *  Author: Tonight丶相拥
 *  Date: 2021/10/13
 *  Description: 
 **/

import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/http/http_channel.dart';

class RegisterModel extends AppModel {
  Future register(
      {required String account,
      required String password,
      required String rePassword}) async {
    show();
    var result = await HttpChannel.channel
        .register(
            account: account,
            password: password,
            rePassword: rePassword,
            code: "",
            deviceCode: "")
        .then((value) => value.finalize<WrapperModel>(
            wrapper: WrapperModel(),
            failure: (e) => showToast(e),
            success: (_) => dismiss()));
    return result.isSuccess;
  }
}
