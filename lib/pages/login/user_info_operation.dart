/*
 *  Copyright (C), 2015-2021
 *  FileName: user_info_operation
 *  Author: Tonight丶相拥
 *  Date: 2021/12/22
 *  Description: 
 **/

import 'dart:async';

import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../advertising/type.dart';

class UserInfoOperation {

  Future<InitializePage> userInfo({void Function(String)? failure,
    void Function()? success}){
    Completer<InitializePage> completer = Completer();
    HttpChannel.channel.userInfo()
        .then((value) => value.finalize(
        wrapper: WrapperModel(),
        failure: (e) {
          failure?.call(e);
          completer.complete(InitializePage.logIn);
        },
        success: (data) async{
          var user = AppManager.getInstance<AppUser>();
          user.fromJson(data, false);
          var setting = AppManager.getInstance<GlobalSettingModel>();
          setting.startUploadFireBaseKey();
          setting.appUpgrade();
          await imLogIn();
          success?.call();
          completer.complete(InitializePage.tab);
        }
    ));
    return completer.future;
  }

  Future<void> imLogIn() async{
    try {
      if (await EMClient.getInstance.isLoginBefore()) {
        await EMClient.getInstance.logout();
      }
      var user = AppManager.getInstance<AppUser>();
      await EMClient.getInstance.login(user.hxAccount!, user.hxPassword!);
      await EMClient.getInstance.chatManager.loadAllConversations();
    }catch(e) {
      print("");
    }
  }
}