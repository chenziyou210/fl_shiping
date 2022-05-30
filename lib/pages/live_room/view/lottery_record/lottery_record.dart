/*
 *  Copyright (C), 2015-2021
 *  FileName: lottery_record
 *  Author: Tonight丶相拥
 *  Date: 2021/11/27
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/pages/live_room/view/game_view/game_item.dart';
import 'lottery_record_logic.dart';
import '../baccarat_game_widget/baccarat_game_widget.dart';

class LotteryRecord extends StatefulWidget {
  LotteryRecord(this.gameName, {this.height});
  final String gameName;
  final double? height;
  @override
  createState()=> _LotteryRecordState(gameName);
}

class _LotteryRecordState extends State<LotteryRecord> {
  _LotteryRecordState(String name): controller = LotteryRecordLogic(name);
  final LotteryRecordLogic controller;
  final Size _size1 = Size(20, 20);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(controller);
    controller.dataRefresh();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<LotteryRecordLogic>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: widget.height ?? context.height / 2,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 23, 35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10))
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Image.asset(AppImages.imageBase + widget.gameName + ".png",
                width: 15, height: 15),
              SizedBox(width: 4),
              CustomText("${widget.gameName}", fontSize: 16,
                fontWeight: w_500, color: Colors.white)
            ]
          ),
          SizedBox(height: 16),
          RefreshWidget(
            enablePullUp: true,
            onRefresh: (c) async{
              await controller.dataRefresh();
              c.refreshCompleted();
              c.resetNoData();
            },
            onLoading: (c) async{
              await controller.loadMore();
              if (controller.hasMoreData) {
                c.loadComplete();
              }else {
                c.loadNoData();
              }
            },
            children: [
              Obx((){
                if (controller.data.length == 0)
                  return SliverFillRemaining();
                return SliverList(delegate: SliverChildBuilderDelegate((_, index){
                  var model = controller.data[index];
                  List<String> r = model.gameResultStrPic?.split("+") ?? [];
                  Size size = _size1;
                  if (model.gameName == "RacingGame") {
                    if (r.length < 2)
                      return SizedBox();
                    r[1] = r[1].split(",").map((e) => "_" + e).join(",");
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        CustomText("${model.periodTime}", fontSize: 14,
                          fontWeight: w_400, color: Colors.white),
                        SizedBox(height: 4),
                        if (model.gameName == "BaccaratGame")
                          BaccaratGameCell(gameName: widget.gameName, r: r)
                        else
                        Row(
                          children: [
                            if (r.length >= 1)
                            ...r[0].split(",").map((e) => [
                              getItem(widget.gameName, e, size: size),
                              SizedBox(width: 4)
                            ]).reduce((value, element) => value + element)..removeLast(),
                            if (r.length >= 2)
                              [SizedBox(width: 4),
                              CustomText("+", color: Colors.white),
                              SizedBox(width: 4),//.map((e) => "_" + e)
                              ...r[1].split(",").map((e) => [
                                getItem(widget.gameName, e, size: size),
                                SizedBox(width: 4)
                              ]).reduce((value, element) => value + element)..removeLast()].row(),
                            if (r.length >= 3)
                              [SizedBox(width: 4),
                                CustomText("+", color: Colors.white),
                                SizedBox(width: 4),
                                ...r[2].split(",").map((e) => [
                                  getItem(widget.gameName, e, size: size),
                                  SizedBox(width: 4)
                                ]).reduce((value, element) => value + element)..removeLast()].row(),
                            if (r.length >= 4)
                              [SizedBox(width: 4),
                                CustomText("+", color: Colors.white),
                                SizedBox(width: 4),
                                ...r[3].split(",").map((e) => [
                                  getItem(widget.gameName, e, size: size),
                                  SizedBox(width: 4)
                                ]).reduce((value, element) => value + element)..removeLast()].row(),
                          ]
                        ),
                        SizedBox(height: 4),
                        CustomDivider(color: Color.fromARGB(255, 39, 42, 60)),
                      ]
                    ),
                  );
                }, childCount: controller.data.length));
              })
            ]
          ).expanded()
        ]
      )
    );
  }
}