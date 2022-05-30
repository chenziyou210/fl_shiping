/*
 *  Copyright (C), 2015-2021
 *  FileName: bet_record_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'dart:convert';

import 'package:get/get.dart';
import 'package:hjnzb/generated/bet_record_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'query_base_logic.dart';

class BetRecordLogic extends QueryBaseLogic<BetRecordEntity> {
  /// 投注总额
  RxDouble _betAmountMoney = 0.0.obs;
  RxDouble get betAmountMoney => _betAmountMoney;

  /// 收益总额
  RxDouble _gainAmountMoney = 0.0.obs;
  RxDouble get gainAmountMoney => _gainAmountMoney;

  @override
  Future<bool> getData(int page, {int? id, String? orderNo,
    required void Function(List<BetRecordEntity> data) success}) {
    // TODO: implement getData
    return HttpChannel.channel.betRecord(page: page, timeType: id).then((value) {
      return value.finalize<WrapperModel>(
          wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (data) {
          double value = double.parse((data["totalInvestMoney"] ?? 0).toString());
          double value1 = double.parse((data["totalIncomeMoney"] ?? 0).toString());
          Map lst = data["list"] ?? {};
          List l = lst["records"] ?? [];
          this._betAmountMoney.value = value;
          this._gainAmountMoney.value = value1;
          success(l.map((e) {
            var model = BetRecordEntity.fromJson(e);
            try {
              model.bets = jsonDecode(model.betJson ?? "");
            }catch(_){

            }
            return model;
          }).toList());
        }
      ).isSuccess;
    });
  }
}