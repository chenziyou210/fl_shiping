/*
 *  Copyright (C), 2015-2021
 *  FileName: charge_record
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/util_tool/string_extension.dart';
import 'package:get/get.dart';
import 'query_base.dart';
import 'query_enum.dart';
import 'charge_record_logic.dart';

class ChargeRecordPage extends StatefulWidget {
  @override
  createState()=> _ChargeRecordPageState();
}

class _ChargeRecordPageState extends QueryBase<ChargeRecordPage> {

  final ChargeRecordLogic controller = ChargeRecordLogic();

  @override
  // TODO: implement queries
  List<QueryType> get queries => [
    QueryType.time,
    QueryType.all
  ];
  
  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.chargeRecord}",
      fontWeight: w_500,
      color: Color.fromARGB(255, 34, 40, 49),
      fontSize: 16.pt
    )
  );

  @override
  // TODO: implement body
  Widget get body => Column(
      children: [
        super.body.expanded(),
        SizedBox(height: 4),
        Container(
          height: 74.pt,
          width: this.width,
          color: Colors.white,
          padding: EdgeInsets.only(left: 31),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText("${intl.totalCharge}",
                    fontSize: 14.pt,
                    fontWeight: w_400,
                    color: Color.fromARGB(255, 81, 77, 77)
                ),
                SizedBox(height: 4),
                Obx((){
                  return CustomText("${controller.total.value}",
                      fontSize: 16.pt,
                      fontWeight: w_bold,
                      color: Colors.black
                  );
                })
              ]
          ),
        )
      ]
  );

  @override
  Widget cellAtIndex(int index) {
    // TODO: implement cellAtIndex
    var model = controller.data[index];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8) + EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              Spacer(),
              CustomText("${_getState(model.payStatus!)}",
                fontWeight: w_600,
                fontSize: 16.pt,
                color: Colors.black
              ),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          CustomDivider(color: Color.fromARGB(255, 244, 244, 244)),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.orderNumber}", style: _style),
              Spacer(),
              CustomText("${model.id}", style: _style),
              SizedBox(width: 4),
              copy("${model.id}"),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.time}", style: _style),
              Spacer(),
              CustomText("${model.createTime}".getDateTime, style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.payWay}", style: _style),
              Spacer(),
              CustomText("${model.paySource}", style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.chargeAmount}", style: _style),
              Spacer(),
              CustomText("${model.money}",
                fontSize: 14.pt,
                fontWeight: w_bold,
                color: Color.fromARGB(255, 81, 77, 77)
              ),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Wrap(
                children: [
                  CustomText("${intl.note}: ${model.remark}", style: _style)
                ],
              ).expanded()
            ]
          ),
          SizedBox(height: 8)
        ]
      ),
    );
  }

  final TextStyle _style = TextStyle(
    fontSize: 14.pt,
    fontWeight: w_400,
    color: Color.fromARGB(255, 81, 77, 77)
  );

  String _getState(int state){
    if (state == 0) {
      return intl.waitingForPay;
    }else if (state == 1){
      return intl.alreadyPay;
    }
    return "";
  }
}