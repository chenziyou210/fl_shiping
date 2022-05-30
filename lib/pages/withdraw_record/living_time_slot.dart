/*
 *  Copyright (C), 2015-2021
 *  FileName: living_time_slot
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/util_tool/string_extension.dart';
import 'query_enum.dart';
import 'query_base.dart';
import 'living_time_slot_logic.dart';

class LivingTimeSlotPage extends StatefulWidget {
  @override
  createState()=> _LivingTimeSlotPageState();
}

class _LivingTimeSlotPageState extends QueryBase<LivingTimeSlotPage> {
  
  @override
  // TODO: implement queries
  List<QueryType> get queries => [
    QueryType.time
  ];
  
  final LivingTimeSlotLogic controller = LivingTimeSlotLogic();
  
  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.livingTimeSlot}", 
      fontWeight: w_500,
      fontSize: 16.pt,
      color: Color.fromARGB(255, 34, 40, 49)
    )
  );
  
  @override
  Widget cellAtIndex(int index) {
    // TODO: implement cellAtIndex
    var model = controller.data[index];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8) + EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(left: 8, right: 4) + EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomText("${intl.startTime}", style: _style),
              Spacer(),
              CustomText("${intl.endTime}", style: _style)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${model.created}".getDateTime, style: _style),
              Spacer(),
              CustomText("${model.closetime ?? "--"}".getDateTime, style: _style)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Spacer(),
              CustomText("${_getState(model.state!)}",
                fontSize: 14.pt,
                fontWeight: w_400,
                color: model.state == 0 ? Color.fromARGB(255, 228, 31, 39)
                    : Color.fromARGB(255, 18, 195, 132),
              )
            ]
          )
        ]
      )
    );
  }
  
  final TextStyle _style = TextStyle(
    fontSize: 14.pt,
    fontWeight: w_400,
    color: Color.fromARGB(255, 80, 77, 77)
  ); 
  
  String _getState(int state){
    if (state == 1) {
      return intl.living;
    }else if (state == 2){
      return intl.offLine;
    }else if (state == 3) {
      return intl.forbidden;
    } 
    return "";
  }
}