/*
 *  Copyright (C), 2015-2021
 *  FileName: living_time_slot_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:hjnzb/generated/living_time_slot_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

import 'query_base_logic.dart';

class LivingTimeSlotLogic extends QueryBaseLogic<LivingTimeSlotEntity> {
  @override
  Future<bool> getData(int page, {int? id, String? orderNo,
    required void Function(List<LivingTimeSlotEntity> data) success}) {
    // TODO: implement getData
    return HttpChannel.channel.livingTimeSlot(page: page, timeType: id).then((value) {
      return value.finalize<WrapperModel>(
        wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (data) {
          List lst = data["data"] ?? [];
          success(lst.map((e) => LivingTimeSlotEntity.fromJson(e)).toList());
        }
      ).isSuccess;
    });
  }
}