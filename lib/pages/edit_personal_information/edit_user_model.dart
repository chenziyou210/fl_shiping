/*
 *  Copyright (C), 2015-2021
 *  FileName: edit_user_model
 *  Author: Tonight丶相拥
 *  Date: 2021/7/16
 *  Description: 
 **/

import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/util_tool/util_tool.dart';

class EditUserModel extends AppModel {
  UserModel user = UserModel();

  /// 更新头像
  void updateAvatar(String filePath){
    // todo 上传头像
    user.updateAvatar(filePath);
    HttpChannel.channel.uploadImage(filePath).then((value) =>
        value.finalize(
          wrapper: WrapperModel(),
          success: (url) {
            user.avatar = url;
          }
        ));
  }

  /// 更新姓名
  void updateName(String name){
    user.updateName(name);
  }

  /// 更新性别
  void updateGender(int gender){
    user.updateGender(gender);
  }

  /// 更新出生日期
  void updateBirthday(String date){
    user.updateBirthday(date);
  }

  /// 更新家乡
  void updateHomeTown(String homeTown){
    user.updateHomeTown(homeTown);
  }

  /// 更新职位
  void updateProfession(String profession){
    user.updateProfession(profession);
  }

  /// 更新情感
  void updateFeeling(String feeling){
    user.updateFeeling(feeling);
  }

  /// 更新签名
  void updateSignature(String signature){
    user.updateSignature(signature);
  }

  /// 保存
  void save({Function? onSuccess}){
    show();
    String? bir = user._birthdayTime?.toIso8601String();
    if (bir != null) {
      bir = bir.substring(0,10) + " " +  bir.substring(11, 19);
    }
    HttpChannel.channel.editUserInfo(
      name: user.name,
      profession: user.profession,
      emotion: user.feeling,
      birthday: bir,//user._birthdayTime?.millisecondsSinceEpoch,
      sex: user.gender,
      signature: user.signature,
      city: user.hometown,
      avatar: user.avatar
    )..then((value) => value.finalize(
        wrapper: WrapperModel(),
        failure: (e) {
          showToast(e);
        },
        success: (_){
          dismiss();
          var value = {
            "birthday": user._birthdayTime?.toIso8601String(),
            "city": user.hometown,
            "emotion": user.feeling,
            "header": user.avatar,
            "name": user.name,
            "profession": user.profession,
            "sex": user.gender ?? 0,
            "signature": user.signature
          };
          AppManager.getInstance<AppUser>().userUpdate(value);
          value["birthday"] = user._birthdayTime?.millisecondsSinceEpoch;
          onSuccess?.call(value);
        }));
  }
}

class UserModel extends CommonNotifierModel {
  // 头像
  String? avatar;
  // 姓名
  String? name;
  // 账号
  String account = "26353748530";
  // 性别
  int? gender;
  // 出生日期
  String? birthday;
  DateTime? _birthdayTime;
  DateTime? get birthdayTime => _birthdayTime;
  // 星座
  String? constellation;
  // 家乡
  String? hometown;
  // 职业
  String? profession;
  // 情感
  String? feeling;
  // 签名
  String? signature;

  /// 更新头像
  void updateAvatar(String filePath){
    this.avatar = filePath;
    updateState();
  }

  /// 更新姓名
  void updateName(String name){
    this.name = name;
    updateState();
  }

  /// 更新性别
  void updateGender(int gender){
    this.gender = gender;
    updateState();
  }

  /// 更新出生日期
  void updateBirthday(String date){
    this.birthday = date;
    _birthdayTime = DateTimeExtension.fromString(date);
    updateState();
  }

  /// 更新家乡
  void updateHomeTown(String homeTown){
    this.hometown = homeTown;
    updateState();
  }

  /// 更新职位
  void updateProfession(String profession){
    this.profession = profession;
    updateState();
  }

  /// 更新情感
  void updateFeeling(String feeling){
    this.feeling = feeling;
    updateState();
  }

  /// 更新签名
  void updateSignature(String signature){
    this.signature = signature;
    updateState();
  }

  void fromJson(Map<String, dynamic> json){
    this.name = json["name"];
    this.hometown = json["hometown"];
    this.signature = json["signature"];
    int? birthday = json["birthday"];
    try{
      _birthdayTime = DateTime.fromMillisecondsSinceEpoch(birthday!);
    }catch(_) {

    }
    if (_birthdayTime != null) {
      this.birthday =  _birthdayTime!.toFormatString(DateTimeFormat.yyyy_MM_dd);
    }
    this.feeling = json["feeling"];
    this.profession = json["profession"];
    this.constellation = json["constellation"];
    this.avatar = json["header"];
    this.account = json["memberId"] ?? "";
    this.gender = json["sex"];
  }
}
/*
* {"header":" ","username":"eeee1","rank":null,"attentionNum":0,
* "fansNum":0,"memberId":"1242623627","profession":"不知道哈哈哈",
* "hometown":null,"feeling":null,"signature":"风中有朵雨做的云",
* "sendOut":null, "name":"xxc","id":null,"sex":1,
* "birthday":"2021-07-31T17:04:36","rogerThat":null,
* "constellation":"狮子座"}*/