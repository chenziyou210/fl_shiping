/*
 *  Copyright (C), 2015-2021
 *  FileName: withdraw_new_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/11/30
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/bank_list_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/manager/app_manager.dart';

class WithdrawLogic extends GetxController with Toast {
  final _WithdrawLogicState state = _WithdrawLogicState();

  /// 获取数据
  Future getData(){
    return Future.wait([
      HttpChannel.channel.userInfo().then((value)
        => value.finalize(
          wrapper: WrapperModel(),
          success: (data){
            AppManager.getInstance<AppUser>().fromJson(data, false);
          }
        )),
      HttpChannel.channel.bindBankList().then((value)
        => value.finalize(
          wrapper: WrapperModel(),
          success: (data) {
            List lst = data ?? [];
            state._setData(lst.map((e) => BankListEntity.fromJson(e)).toList());
          }
        ))
    ]);
  }

  /// 设置数据
  void setData(BankListEntity entity){
    state._setData([entity]);
  }

  var _intl = AppInternational.current;

  /// 提现
  void withdraw(String money, String password){
    if (state.data.length <= 0) {
      showToast(_intl.pleaseChooseBank);
      return;
    }
    double m = 0;
    try {
      m = double.parse(money);
    }catch(e) {
      showToast(e.toString());
      return;
    }

    if (m == 0) {
      showToast(_intl.pleaseEnterWithdrawMoney);
      return;
    }
    if (password.isEmpty) {
      showToast(_intl.pleaseEnterWithdrawPassword);
      return;
    }
    var model = state.data[0];
    show();
    HttpChannel.channel.withdrawNew(bindBankId: model.id!,
      money: m,
      withdrawPassword: password).then((value)=> value.finalize(
        wrapper: WrapperModel(),
      failure: (e)=> showToast(e),
      success: (_) {
          dismiss();
      }
    ));
  }
}

class _WithdrawLogicState {

  RxList<BankListEntity> _data = <BankListEntity>[].obs;
  RxList<BankListEntity> get data => _data;

  /// 设置数据
  void _setData(List<BankListEntity> data){
    _data.value = data;
  }
}