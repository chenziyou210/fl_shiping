/*
 *  Copyright (C), 2015-2021
 *  FileName: account_detail_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/generated/account_detail_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

import "query_base_logic.dart";

class AccountDetailLogic extends QueryBaseLogic<AccountDetailEntity>{
  RxDouble _total = 0.0.obs;
  RxDouble get total => _total;

  @override
  Future<bool> getData(int page, {int? id, String? orderNo,
    required void Function(List<AccountDetailEntity> data) success}) {
    // TODO: implement getData
    return HttpChannel.channel.accountDetail(page: page,
        id: orderNo, timeType: id).then((value) {
      return value.finalize<WrapperModel>(
          wrapper: WrapperModel(),
          failure: (e) => showToast(e),
          success: (data) {
            List lst = data["page"]["records"] ?? [];
            double total = double.parse((data["toltalBrushValue"] ?? 0).toString());
            this._total.value = total;
            success(lst.map((e) => AccountDetailEntity.fromJson(e)).toList());
          }
      ).isSuccess;
    });
  }
}