/*
 *  Copyright (C), 2015-2021
 *  FileName: personal_information_model
 *  Author: Tonight丶相拥
 *  Date: 2021/7/31
 *  Description: 
 **/

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/generated/user_info_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

class PersonalInformationModel extends AppModel {
  late UserInfoViewModel viewModel;

  @override
  Future loadData() {
    // TODO: implement loadData
    var value = HttpChannel.channel.userInfo()..then((value) =>
        value.finalize(
          wrapper: WrapperModel(),
          failure: (e) {
            showToast(e);
          },
          success: (data) {
            UserInfoViewModel.fromJson(data);
          }
        ));
    return value;
  }
}

class UserInfoViewModel extends UserInfoEntity with ChangeNotifier {

  factory UserInfoViewModel.fromJson(Map<String ,dynamic> json) => UserInfoEntity.fromJson(json) as UserInfoViewModel;

  void updateData(Map<String, dynamic> json){
    this.birthday = json["birthday"];
    this.hometown = json["city"];
    this.feeling = json["emotion"];
    this.header = json["header"];
    this.name = json["name"];
    this.profession = json["profession"];
    this.sex = json["sex"];
    this.signature = json["signature"];
    if (this.hasListeners) {
      this.notifyListeners();
    }
  }

  @override
  // TODO: implement runtimeType
  Type get runtimeType => UserInfoEntity;
}