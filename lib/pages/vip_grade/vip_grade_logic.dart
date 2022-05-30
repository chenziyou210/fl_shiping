/*
 *  Copyright (C), 2015-2021
 *  FileName: vip_grade_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/8
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/user_grade_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

class VipGradeLogic extends GetxController with Toast {
  final _VipGradeState state = _VipGradeState();

  /// vip 等级
  void getGrade(){
    show();
    HttpChannel.channel.gradeList().then((value) {
      return value.finalize(
        wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (data) {
          UserGradeEntity e = UserGradeEntity.fromJson(data);
          state._setGrade(e);
          dismiss();
        }
      );
    });
  }
}

class _VipGradeState {
  Rx<UserGradeEntity> _entity = UserGradeEntity().obs;
  Rx<UserGradeEntity> get gradeEntity => _entity;

  void _setGrade(UserGradeEntity grade){
    _entity.value = grade;
  }
}