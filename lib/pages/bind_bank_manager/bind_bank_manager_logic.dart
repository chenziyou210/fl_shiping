/*
 *  Copyright (C), 2015-2021
 *  FileName: bind_bank_manager_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/11/29
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/bank_list_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

class BindBankManagerLogic extends GetxController with Toast {
  final _BindBankManagerState state = _BindBankManagerState();

  /// 修改状态
  void toggleState(){
    state._toggleState();
  }

  Future loadData(){
    show();
    return HttpChannel.channel.bindBankList().then((value) =>
      value.finalize(
        wrapper: WrapperModel(),
        failure: (e) => showToast(e),
        success: (data){
          dismiss();
          List lst = data ?? [];
          state._setData(lst.map((e) => BankListEntity.fromJson(e)).toList());
        }));
  }

  void delete(int index){
    show();
    var model = state.data[index];
    HttpChannel.channel.deleteBindBank(model.id!).then((value) =>
      value.finalize(wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (_) {
          dismiss();
          state.data.removeAt(index);
        }
      ));
  }
}

class _BindBankManagerState {

  RxBool _unBinding = false.obs;
  RxBool get unBinding => _unBinding;

  RxList<BankListEntity> _data = RxList();
  RxList<BankListEntity> get data => _data;

  void _setData(List<BankListEntity> data){
    _data.value = data;
  }

  void _toggleState(){
    _unBinding.value = !_unBinding.value;
  }
}