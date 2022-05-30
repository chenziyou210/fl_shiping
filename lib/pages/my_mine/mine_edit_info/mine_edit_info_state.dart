import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hjnzb/manager/app_manager.dart';

enum infoTypes{
  avatar,
  nickname,
  account,
  sex,
  birthday,
  feeling,
  hometown,
  profession,
  signature
}

class MineEditInfoState {
  final AppUser user = AppManager.getInstance<AppUser>();
  final List feelings = ['恋爱', '单身', '未婚'];
  final List selectImageTypes = ['拍照', '从相册选择', '取消'];
  final List sexList = ['男', '女'];
  final List professions = ['歌手', '演员', '模特', '程序员', '公务员', '大佬'];
  final signMaxCount = 32;

  final editInfoModel = EditInfoModel().obs;
  late TextEditingController signatureTEC;
  final signCount = 0.obs;

  MineEditInfoState() {
    final AppUser user = AppManager.getInstance<AppUser>();
    editInfoModel.value = EditInfoModel(
      avatar: user.header,
      nickname: user.name,
      account: user.userId,
      sex: user.sex,
      birthday: user.birthday,
      feeling: user.feeling,
      hometown: user.hometown,
      profession: user.profession,
      signature: user.signature
    );
    signatureTEC = TextEditingController();
  }
}

class EditInfoModel {
  String avatar;
  String nickname;
  String account;
  int sex;
  String birthday;
  String feeling;
  String hometown;
  String profession;
  String signature;

  static var _catheInfo = EditInfoModel(
      avatar: '',
      nickname: '',
      account: '',
      sex: 0,
      birthday: '',
      feeling: '',
      hometown: '',
      profession: '',
      signature: 'TA好像忘记签名了'
  );

  factory EditInfoModel({
    String? avatar,
    String? nickname,
    String? account,
    int? sex,
    String? birthday,
    String? feeling,
    String? hometown,
    String? profession,
    String? signature}) {
    final i = EditInfoModel._init(
      avatar ?? _catheInfo.avatar,
      nickname ?? _catheInfo.nickname,
      account ?? _catheInfo.account,
      sex ?? _catheInfo.sex,
      birthday ?? _catheInfo.birthday,
      feeling ?? _catheInfo.feeling,
      hometown ?? _catheInfo.hometown,
      profession ?? _catheInfo.profession,
      signature ?? _catheInfo.signature
    );
    _catheInfo = i;
    return i;
  }

  EditInfoModel._init(
      this.avatar,
      this.nickname,
      this.account,
      this.sex,
      this.birthday,
      this.feeling,
      this.hometown,
      this.profession,
      this.signature
      );
}