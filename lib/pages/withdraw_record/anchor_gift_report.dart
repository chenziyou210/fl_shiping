/*
 *  Copyright (C), 2015-2021
 *  FileName: anchor_gift_report
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/util_tool/string_extension.dart';
import 'anchor_gift_report_logic.dart';
import 'query_enum.dart';
import 'query_base.dart';

class AnchorGiftReportPage extends StatefulWidget {
  @override
  createState()=> _AnchorGiftReportPageState();
}

class _AnchorGiftReportPageState extends QueryBase<AnchorGiftReportPage> {

  final AnchorGiftReportLogic controller = AnchorGiftReportLogic();

  @override
  // TODO: implement queries
  List<QueryType> get queries => [
    QueryType.time
  ];

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.giftReport}",
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
              CustomText("${intl.gift}", style: _style),
              Spacer(),
              ExtendedImage.network("${model.picurl}",
                  width: 37.pt,
                  height: 37.pt,
                  fit: BoxFit.fill
              ),
              SizedBox(width: 4)
            ],
          ),
          SizedBox(height: 8),
          CustomDivider(color: Color.fromARGB(255, 244, 244, 244)),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.price}:", style: _style),
              Spacer(),
              CustomText("${model.coins}",
                fontSize: 14.pt,
                fontWeight: w_600,
                color: Color.fromARGB(255, 228, 31, 39)
              ),
              SizedBox(width: 4),
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.number}:", style: _style),
              Spacer(),
              CustomText("x${model.num}", style: _style),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.time}:", style: _style),
              Spacer(),
              CustomText("${model.created}".getDateTime, style: _style),
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
      SizedBox(height: 8),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        color: Colors.white,
        height: 74.pt,
        child: Row(
          children: [
            CustomText("${intl.giftGainAmount}", style: _style),
            Spacer(),
            Obx(() => CustomText("${controller.total.value}",
                fontSize: 16.pt,
                fontWeight: w_bold,
                color: Color.fromARGB(255, 228, 31, 39)
            ))
          ]
        )
      )
    ]
  );
  
  final TextStyle _style = TextStyle(
    fontSize: 14.pt,
    fontWeight: w_400,
    color: Color.fromARGB(255, 80, 77, 77)
  );
}