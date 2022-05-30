/*
 *  Copyright (C), 2015-2021
 *  FileName: app_manager
 *  Author: Tonight丶相拥
 *  Date: 2021/10/16
 *  Description: 
 **/

library appmanager;


import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/share_app_link_entity.dart';
import 'package:hjnzb/http/cache.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/config.dart' as a;
import 'package:hjnzb/http/http_channel.dart';
// import 'package:hjnzb/i18n/local_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../generated/im_room_account.dart';
import '../generated/upgrade_entity.dart';
import 'dart:math' as math;
// import 'package:hjnzb/pages/chats_list/chats_list_model.dart';
// import 'package:tencent_im_sdk_plugin/enum/V2TimConversationListener.dart';
// import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
// import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';


part 'user.dart';
// part 'chats.dart';
part 'global_setting_model.dart';
part 'game_manager.dart';
part 'token_mixin.dart';

class AppManager {

  AppManager._();

  static AppUser _user = AppUser._();
  // static ChatsListViewModel _chats = ChatsListViewModel._();
  static GlobalSettingModel _setting = GlobalSettingModel._();
  static Game _game = Game._();

  static T getInstance<T>() {
    String type = T.toString();
    T? t;
    if (type == (AppUser).toString()) {
      t = _user as T;
    // }else if (type == (ChatsListViewModel).toString()) {
    //   t = _chats as T;
    }else if (type == (GlobalSettingModel).toString()) {
      t = _setting as T;
    }else if (type == (Game).toString())
      t = _game as T;
    if (t == null) {
      throw("type T is null");
    }
    return t;
  }
}