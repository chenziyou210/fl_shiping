/*
 *  Copyright (C), 2015-2021
 *  FileName: bind_bank_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/11/29
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/system_bank_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';

class BindBankLogic extends GetxController with Toast {
  final _BindBankState state = _BindBankState();

  void getData(){
    HttpChannel.channel.systemBankList().then((value) =>
      value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data ?? [];
          state._setData(lst.map((e) => SystemBankEntity.fromJson(e)).toList());
        }
      ));
  }

  void setValue(String value){
    state._selectValue(value);
  }

  var _intl = AppInternational.current;

  void onSubmit(String name, String onlineBankAccount, String confirmAccount, VoidCallback success){
    if (state.value.isEmpty) {
      showToast(_intl.pleaseChooseOpeningBank);
      return;
    }else if (name.isEmpty) {
      showToast(_intl.nameEmptyPleaseCheck);
      return;
    }else if (onlineBankAccount.isEmpty) {
      showToast(_intl.onlineBankEmptyPleaseCheck);
      return;
    }else if (confirmAccount.isEmpty) {
      showToast(_intl.confirmAccountEmptyPleaseCheck);
      return;
    }else if (onlineBankAccount != confirmAccount) {
      showToast(_intl.confirmAccountNotEqualOnlineBackAccount);
      return;
    }
    var lst = state._data.where((element) => element.thirdBankId == state.value.value).toList();
    if (lst.length == 0) {
      showToast(_intl.pleaseChooseBank);
      return ;
    }
    var model = lst[0];
    show();
    HttpChannel.channel.bindBankModify(
        purseChannel: model.id!,
        name: name, bankname: model.bankName!,
        cardNumber: onlineBankAccount, accountob: "",
        remark: "").then((value)
    => value.finalize(
      wrapper: WrapperModel(),
      failure: (e)=> showToast(e),
      success: (data) {
        dismiss();
        _reset();
        success();
      }
    ));
  }

  void _reset(){
    state._value.value = "";
  }
}

class _BindBankState {
  RxString _value = "".obs;
  RxString get value => _value;

  RxList<SystemBankEntity> _data = [
    SystemBankEntity()..bankName = AppInternational.current.pleaseChoose//"请选择"
      ..thirdBankId = ""
  ].obs;
  RxList<SystemBankEntity> get data => _data;

  void _setData(List<SystemBankEntity> data){
    _data += data;
  }

  void _selectValue(String value){
    _value.value = value;
  }
}