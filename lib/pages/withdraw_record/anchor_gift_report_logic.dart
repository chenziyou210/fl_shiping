/*
 *  Copyright (C), 2015-2021
 *  FileName: anchor_gift_report_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/generated/anchor_gift_report_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

import 'query_base_logic.dart';

class AnchorGiftReportLogic extends QueryBaseLogic<AnchorGiftReportEntity>{
  RxDouble _total = 0.0.obs;
  RxDouble get total => _total;

  @override
  Future<bool> getData(int page, {int? id, String? orderNo,
    required void Function(List<AnchorGiftReportEntity> data) success}) {
    // TODO: implement getData
    return HttpChannel.channel.giftFormReport(page: page, timeType: id).then((value) {
      return value.finalize<WrapperModel>(
          wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (data) {
            List lst = data["page"]["records"] ?? [];
            double total = double.parse((data["totalvalue"] ?? 0).toString());
            this._total.value = total;
            success(lst.map((e) => AnchorGiftReportEntity.fromJson(e)).toList());
        }
      ).isSuccess;
    });
  }

}