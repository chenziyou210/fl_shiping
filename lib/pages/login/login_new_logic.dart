/*
 *  Copyright (C), 2015-2021
 *  FileName: login_new_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/6
 *  Description: 
 **/

import 'dart:async';

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import '../../http/cache.dart';
import 'user_info_operation.dart';
// import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class LogInLogic extends GetxController with Toast{
  final _LogInState state = _LogInState();

  void toggleSecurityLock(){
    state._toggleSecurityLock();
  }

  Future<bool> logIn(String account, String password, String? type){

    Completer<bool> completer = Completer();
    show();
    HttpChannel.channel.logIn(account, password, type: type)
        .then((value) => value.finalize(
        wrapper: WrapperModel(),
        failure: (e) {
          showToast(e);
          completer.complete(false);
        },
        success: (data) {
          var user = AppManager.getInstance<AppUser>();
          user.setToken(data);
          AppCacheManager.cache.setisGuest(false);
          UserInfoOperation().userInfo(
            failure: (e) {
              showToast(e);
              completer.complete(false);
            },
            success: (){
              dismiss();
              completer.complete(true);
            }
          );
        }
    ));
    return completer.future;
  }
}

class _LogInState {
  /// 是否显示
  RxBool _isShow = true.obs;
  RxBool get isShow => _isShow;

  void _toggleSecurityLock(){
    _isShow.value = !_isShow.value;
  }
}