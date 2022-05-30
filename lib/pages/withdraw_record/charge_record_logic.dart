/*
 *  Copyright (C), 2015-2021
 *  FileName: charge_record_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:hjnzb/generated/charge_record_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:get/get.dart';
import 'query_base_logic.dart';


class ChargeRecordLogic extends QueryBaseLogic<ChargeRecordEntity>{

  RxDouble _total = 0.0.obs;
  RxDouble get total => _total;
  @override
  Future<bool> getData(int page, {int? id, String? orderNo,
    required void Function(List<ChargeRecordEntity> data) success}) {
    return HttpChannel.channel.chargeRecord(page: page, timeType: id).then((value) {
      return value.finalize<WrapperModel>(
        wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (data) {
          List lst = data["page"]["records"] ?? [];
          double total = double.parse((data["toltalRechargeValue"] ?? 0).toString());
          this._total.value = total;
          success(lst.map((e) => ChargeRecordEntity.fromJson(e)).toList());
        }
      ).isSuccess;
    });
  }

}