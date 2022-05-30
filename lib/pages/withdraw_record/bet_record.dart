/*
 *  Copyright (C), 2015-2021
 *  FileName: bet_record
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/util_tool/string_extension.dart';
import '../live_room/view/game_view/game_item.dart';
import 'query_base.dart';
import 'bet_record_logic.dart';
import 'query_enum.dart';

class BetRecordPage extends StatefulWidget {
  @override
  createState()=> _BetRecordPageState();
}

class _BetRecordPageState extends QueryBase<BetRecordPage> {

  final BetRecordLogic controller = BetRecordLogic();

  @override
  // TODO: implement queries
  List<QueryType> get queries => [
    QueryType.time,
    QueryType.all
  ];

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.betRecord}",
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
      SizedBox(height: 8),
      Container(
        height: 74.pt,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText("${intl.betAmount}", style: _style),
                SizedBox(height: 4),
                Obx((){
                  return CustomText("${controller.betAmountMoney.value}",
                    fontSize: 16.pt,
                    fontWeight: w_bold,
                    color: Color.fromARGB(255, 81, 77, 77),
                  );
                }),
              ]
            ).expanded(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText("${intl.gainAmount}", style: _style),
                SizedBox(height: 4),
                Obx((){
                  return CustomText("+${controller.gainAmountMoney.value}",
                    fontWeight: w_bold,
                    color: Color.fromARGB(255, 228, 31, 39),
                    fontSize: 16.pt
                  );
                })
              ]
            ).expanded()
          ]
        )
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
              CustomText("${model.gameName}",
                fontSize: 16.pt,
                fontWeight: w_600,
                color: Colors.black
              ),
              Spacer(),
              CustomText("${model.settlement == 1 ? intl.betSuccess
                  : intl.settlementSuccess}",
                fontSize: 14,
                fontWeight: w_400,
                color: Colors.black
              ),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          CustomDivider(color: Color.fromARGB(255, 244, 244, 244)),
          SizedBox(height: 8),
          [
            CustomText(intl.bet, style: _style),
            Wrap(
                alignment: WrapAlignment.end,
                runSpacing: 8,
                children: (model.bets?["betList"] ?? []).map<Widget>((e) =>
                    _getItem(model.bets!["gameName"], e["gamePlay"].toString()
                        + "-" + e["betValue"].toString())).toList()
            ).expanded()
          ].row(crossAxisAlignment: CrossAxisAlignment.start),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.dn}", style: _style),
              Spacer(),
              CustomText("${model.periodTime}", style: _style),
              SizedBox(width: 4),
              // copy(model.id?.toString()),
              // SizedBox(width: 4)
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
              CustomText("${intl.bet}", style: _style),
              Spacer(),
              CustomText("${model.coins}", style: _style.copyWith(
                fontWeight: w_600
              )),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CustomText("${intl.gain}", style: _style),
              Spacer(),
              CustomText("${model.gainMoney}",
                fontSize: 14.pt,
                fontWeight: w_400,
                color: Color.fromARGB(255, 228, 31, 39)
              ),
              SizedBox(width: 4)
            ]
          ),
          SizedBox(height: 8)
        ]
      )
    );
  }

  final TextStyle _style = TextStyle(
    fontSize: 14.pt,
    fontWeight: w_400,
    color: Color.fromARGB(255, 80, 77, 77)
  );

  Widget _getItem(String gameName, String value){
    return getItem(gameName, value).paddingOnly(right: 8);
  }
}