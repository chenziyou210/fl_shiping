/*
 *  Copyright (C), 2015-2021
 *  FileName: follow_bet
 *  Author: Tonight丶相拥
 *  Date: 2021/12/20
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/pages/live_room/view/game_view/game_item.dart';

class BetModel {
  BetModel({required this.betNumber,
    required this.betValue,
    required this.gamePlay});
  final String betValue;
  final int gamePlay;
  final int betNumber;
}

class FollowBetWidget extends StatelessWidget with Toast {
  FollowBetWidget(this.gameName, this.id, this.bets, {required this.anchorId});
  final String gameName;
  final String id;
  final String anchorId;
  final List<BetModel> bets;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    var intl = AppInternational.of(context);
    return Container(
      width: size.width,
      height: size.height / 2,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 23, 35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10))
      ),
      child: Column(
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              CustomText(gameName , fontSize: 16.pt,
                fontWeight: w_600,
                color: Colors.white),
              Spacer(),
              CustomText("${intl.at} $id ${intl.period}",
                fontSize: 12.pt, fontWeight: w_500,
                color: Colors.white,
              )
            ]
          ).padding(padding: EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: 8),
          CustomDivider(),
          SizedBox(height: 8),
          ListView.separated(
            itemBuilder: (_, index) {
              var model = bets[index];
              return Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 8),
                  getItem(gameName, "${model.gamePlay}-${model.betValue}"),
                  Spacer(),
                  CustomText("${model.betNumber}",
                    fontSize: 14.pt,
                    fontWeight: w_500,
                    color: Color.fromARGB(255, 255, 147, 185)
                  ),
                  SizedBox(width: 8)
                ]
              );
            },
            separatorBuilder: (_, __)=> SizedBox(height: 8),
            itemCount: bets.length).expanded(),
          Container(
            width: 263.pt,
            height: 44.pt,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.buttonGradientColors
              ),
              borderRadius: BorderRadius.circular(8)
            ),
            alignment: Alignment.center,
            child: CustomText("${intl.confirmWager}",
              fontWeight: w_500,
              color: Colors.white,
              fontSize: 16.pt
            )
          ).cupertinoButton(onTap: (){
            //result["gameName"] = gameName;
            //     result["periodTime"] = lastPeriodTime;
            //     result["anchorId"] = id;
            //     var l = gamePlays.where((element) {
            //       int index = gamePlays.indexOf(element);
            //       var bets = _bets[index];
            //       element._selectIndexes = bets;
            //       return bets.isNotEmpty;
            //     }).map((e) => e._selectIndexes.map((e1) => {
            //       "gamePlay": e.options[e1].gamePlay,
            //       "betNum": _betNum.value,
            //       "betValue": e.options[e1].betValue
            //     }).toList()).toList();
            //     if (l.length == 0) {
            //       return null;
            //     }
            //     /// 具体数据
            //     result["betList"] = l.reduce((value, element) => value + element);
            show();
            HttpChannel.channel.bet({
              "gameName": gameName,
              "periodTime": int.parse(this.id),
              "anchorId": anchorId,
              "betList": bets.map((e) => {
                "gamePlay": e.gamePlay,
                "betNum": e.betNumber,
                "betValue": e.betValue
              }).toList()
            }).then((value) => value.finalize(
              wrapper: WrapperModel(),
              failure: (e) => showToast(e),
              success: (_) {
                showToast("${intl.betSuccess}");
                Navigator.of(context).pop();
              }
            ));
          })
        ]
      )
    );
  }
}
