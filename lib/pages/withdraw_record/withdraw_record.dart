/*
 *  Copyright (C), 2015-2021
 *  FileName: withdraw_record
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/util_tool/string_extension.dart';
import 'package:get/get.dart';
import 'withdraw_logic.dart';
import 'query_base.dart';
import 'query_enum.dart';

class WithdrawRecord extends StatefulWidget {
  @override
  createState()=> _WithdrawRecordState();
}

class _WithdrawRecordState extends QueryBase<WithdrawRecord> {

  late final WithdrawLogic controller = WithdrawLogic();

  List<QueryType> get queries => [
    QueryType.time,
    QueryType.orderNo
  ];
  
  @override
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.withdrawRecord}",
      fontSize: 16.pt,
      fontWeight: w_500,
      color: Color.fromARGB(255, 34, 40, 49)
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
                CustomText("${intl.totalWithdraw}",
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(horizontal: 8) + EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(left: 8),
      child: Column(
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // todo： 状态检查
              CustomText("${_getState(model.state!)}",
                fontSize: 16.pt,
                fontWeight: w_600,
                color: Colors.black
              ),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          CustomDivider(color: Color.fromARGB(255, 244, 244, 244)),
          SizedBox(height: 4),
          Row(
            children: [
              CustomText("${intl.bankName}", style: _style),
              Spacer(),
              CustomText("${model.bankname}", style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.bankCardNumber}", style: _style),
              Spacer(),
              CustomText("${model.cardNumber}", style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.bankCardNumber}", style: _style),
              Spacer(),
              CustomText("${model.accountob}", style: _style),
              SizedBox(width: 4),
              copy("${model.accountob}"),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.time}", style: _style),
              Spacer(),
              CustomText("${model.payTime}".getDateTime, style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.payWay}", style: _style),
              Spacer(),
              CustomText("${model.name}", style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.withdrawMoney}", style: _style),
              Spacer(),
              CustomText("+${model.money}",
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
                  CustomText("${intl.note}: ${model.payRemark}",
                    style: _style
                  )
                ]
              ).expanded()
            ]
          ),
          SizedBox(height: 8)
        ]
      ).clipRRect(radius: BorderRadius.circular(10))
    );
  }

  final TextStyle _style = TextStyle(
    fontSize: 14.pt,
    fontWeight: w_400,
    color: Color.fromARGB(255, 80, 77, 77)
  );
  
  String _getState(int state){
    if (state == 1) {
      return "${intl.applying}";
    }else if (state == 2) {
      return intl.withdrawSuccess;
    }else if (state == 3) {
      return intl.withdrawFailure;
    }
    return "";
  }
}