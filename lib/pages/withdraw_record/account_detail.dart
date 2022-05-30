/*
 *  Copyright (C), 2015-2021
 *  FileName: account_detail
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/util_tool/string_extension.dart';
import 'query_base.dart';
import 'account_detail_logic.dart';

class AccountDetail extends StatefulWidget {
  @override
  createState()=> _AccountDetailState();
}

class _AccountDetailState extends QueryBase<AccountDetail> {

  final AccountDetailLogic controller = AccountDetailLogic();

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.accountDetail}",
      fontSize: 16.pt,
      fontWeight: w_500,
      color: Color.fromARGB(255, 34, 40, 49)
    )
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
              CustomText("${model.specificTypeStr}",
                fontSize: 16.pt,
                fontWeight: w_600,
                color: Colors.black
              ),
              Spacer()
            ]
          ),
          SizedBox(height: 8),
          CustomDivider(color: Color.fromARGB(255, 244, 244, 244)),
          SizedBox(height: 4),
          Row(
            children: [
              CustomText("${intl.orderNumber}", style: _style),
              SizedBox(width: 16),
              // Spacer(),
              CustomText("${model.bizid}", overflow: TextOverflow.ellipsis, style: _style).expanded(),
              SizedBox(width: 4),
              copy("${model.bizid}"),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.time}", style: _style),
              Spacer(),
              CustomText("${model.created}".getDateTime, style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.money}", style: _style),
              Spacer(),
              CustomText("${model.diamond}",
                fontSize: 14.pt,
                fontWeight: w_600,
                color: Color.fromARGB(255, 228, 31, 39)
              ),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.preferential}", style: _style),
              Spacer(),
              CustomText("${model.preferentialMoney}", style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8)
        ]
      )
    );
  }

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
            CustomText("${intl.totalConsumption}",
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

  final TextStyle _style = TextStyle(
    fontSize: 14.pt,
    fontWeight: w_400,
    color: Color.fromARGB(255, 80, 77, 77)
  );
}