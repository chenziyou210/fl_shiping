/*
 *  Copyright (C), 2015-2021
 *  FileName: bet_record
 *  Author: Tonight丶相拥
 *  Date: 2021/12/20
 *  Description: 
 **/


import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/living_room_lottery_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:httpplugin/http_result_container/http_result_container.dart';
import '../game_view/game_item.dart';
import '../lottery_record/lottery_record.dart' as L;
import '../baccarat_game_widget/baccarat_game_widget.dart';

class LotteryRecord extends StatelessWidget {
  final Size _size1 = Size(20, 20);
  final Size _size2 = Size(25, 35);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size1 = MediaQuery.of(context).size;
    var intl = AppInternational.of(context);
    return Container(
      width: size1.width,
      height: size1.height * 0.5,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 23, 35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10))
      ),
      child: Column(
        children: [
          SizedBox(height: 8),
          CustomText("${intl.lotteryRecord}",
            fontSize: 16.pt, fontWeight: w_500,
            color: Colors.white
          ),
          SizedBox(height: 8),
          LoadingWidget(builder: (_, snapshot) {
            Map<String, dynamic> dic = (snapshot.data as HttpResultContainer)
                .finalize<WrapperModel>(wrapper: WrapperModel()).object;
            List lst = dic.keys.toList();
            List<LivingRoomLotteryEntity> data = lst.map((e) {
              return LivingRoomLotteryEntity.fromJson(dic[e]);
            }).toList();
            return ListView.separated(itemBuilder: (_, index) {
              var model = data[index];
              List<String> r = model.lastGameResultStr?.split("+") ?? [];
              Size size = _size1;
              if (model.gameName == "RacingGame") {
                if (r.length < 2)
                  return SizedBox();
                r[1] = r[1].split(",").map((e) => "_" + e).join(",");
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                // height: 64.pt,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 44, 44, 56),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText("${model.gameName}",
                              fontWeight: w_400,
                              color: Colors.white,
                              fontSize: 16.pt
                            ),
                            SizedBox(width: 8),
                            CustomText("${model.lastPeriodTime}",
                              fontSize: 12.pt, color: Color.fromARGB(255, 183, 178, 178),
                              fontWeight: w_400
                            )
                          ]
                        ),
                        SizedBox(height: 8),
                        if (model.gameName == "BaccaratGame")
                          BaccaratGameCell(gameName: model.gameName!, r: r)
                        else
                        Row(
                            children: [
                              if (r.length >= 1)
                                ...r[0].split(",").map((e) => [
                                  getItem(model.gameName!, e, size: size),
                                  SizedBox(width: 4)
                                ]).reduce((value, element) => value + element)..removeLast(),
                              if (r.length >= 2)
                                [SizedBox(width: 4),
                                  CustomText("+", color: Colors.white),
                                  SizedBox(width: 4),//.map((e) => "_" + e)
                                  ...r[1].split(",").map((e) => [
                                    getItem(model.gameName!, e, size: size),
                                    SizedBox(width: 4)
                                  ]).reduce((value, element) => value + element)..removeLast()].row(),
                              if (r.length >= 3)
                                [SizedBox(width: 4),
                                  CustomText("+", color: Colors.white),
                                  SizedBox(width: 4),
                                  ...r[2].split(",").map((e) => [
                                    getItem(model.gameName!, e, size: size),
                                    SizedBox(width: 4)
                                  ]).reduce((value, element) => value + element)..removeLast()].row(),
                              if (r.length >= 4)
                                [SizedBox(width: 4),
                                  CustomText("+", color: Colors.white),
                                  SizedBox(width: 4),
                                  ...r[3].split(",").map((e) => [
                                    getItem(model.gameName!, e, size: size),
                                    SizedBox(width: 4)
                                  ]).reduce((value, element) => value + element)..removeLast()].row(),
                            ]
                        )
                        // Row(
                        //     children: model.lastGameResultStr!.split(",")
                        //         .map((e) => [
                        //       getItem(model.gameName!, e, size: Size(20, 20)),
                        //       SizedBox(width: 4)
                        //     ]).reduce((value, element) =>
                        //       value + element)..removeLast()
                        // )
                      ]
                    ).expanded(),
                    Image.asset(AppImages.forward, color: Colors.white)
                  ]
                )
              ).cupertinoButton(onTap: (){
                customShowModalBottomSheet(
                    context: context,
                    fixedOffsetHeight: size1.height * 0.5,
                    enableDrag: false,
                    builder: (_) {
                      return L.LotteryRecord(model.gameName!);
                    },
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.transparent);
              });
            },
            separatorBuilder: (_, __) => SizedBox(height: 8),
              itemCount: data.length);
          },
              future: HttpChannel.channel.runtimeGame()).expanded()
        ]
      )
    );
  }
}