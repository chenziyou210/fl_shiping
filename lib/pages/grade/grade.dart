/*
 *  Copyright (C), 2015-2021
 *  FileName: grade
 *  Author: Tonight丶相拥
 *  Date: 2021/11/15
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/pages/component_widget/level_widget.dart';

class _ItemModel {
  _ItemModel(this.image, this.text, this.url);
  final String image;
  final String text;
  final String url;
}

class GradePage extends StatefulWidget {
  @override
  createState()=> _GradePageState();
}

class _GradePageState extends AppStateBase<GradePage> {

  final List<_ItemModel> _privilege = [
    _ItemModel(AppImages.birthdayPrivilege, "生日特权", ""),
    _ItemModel(AppImages.upgradeGift, "升级礼包", ""),
    _ItemModel(AppImages.welfare, "福利中心", ""),
    _ItemModel(AppImages.accountPrivilege, "账户特权", "")
  ];
  final List<_ItemModel> _upgrade = [
    _ItemModel(AppImages.giftGiving, "送礼", ""),
    _ItemModel(AppImages.watchLive, "看播", ""),
    _ItemModel(AppImages.share, "分享", "")
  ];

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar();

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => Colors.white;
  
  @override
  // TODO: implement body
  Widget get body => Column(
    children: [
      Row(
        children: [
          SelectorCustom<AppUser, String?>(
            builder: (url) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(22.5),
                child: Container(
                  height: 45,
                  width: 45,
                  child: url == null ? null : ExtendedImage.network(url, fit: BoxFit.cover)
                )
              );
            }, selector: (a) => a.header),
          SizedBox(width: 4),
          SelectorCustom<AppUser, String?>(
            builder: (name) {
              return CustomText("$name",
                fontSize: 20,
                fontWeight: w_bold,
                color: Color.fromARGB(255, 88, 88, 88)
              );
            },
            selector: (a)=> a.name),
          SizedBox(width: 4),
          SelectorCustom<AppUser, int?>(
            builder: (level) {
              return LevelWidget(AppImages.vipBackgroundPurple, level ?? 0);
            },
            selector: (a)=> a.rank),
          Spacer(),
          Image.asset(AppImages.gradeIcon)
        ]
      ).padding(padding: EdgeInsets.symmetric(horizontal: 8)),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
          + EdgeInsets.only(top: 5),
        // height: 200,
        width: this.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 8, 4, 9),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 165, 59, 227).withOpacity(0.35),
              blurRadius: 13.5,
              offset: Offset(0, 6)
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 163, 121, 255),
              Color.fromARGB(255, 101, 95, 255)
            ]
          ),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText("还差10211点升级为VIP7",
                      fontWeight: w_400,
                      fontSize: 12,
                      color: Colors.white
                    ),
                    SizedBox(height: 4),
                    CustomPaint(
                      size: Size(200, 5),
                      painter: LineProgressPainter(
                        percent: 21189 / 32400,
                        radius: BorderRadius.circular(2.5),
                        color: Color.fromARGB(255, 151, 132, 255),
                        colors: [
                          Color.fromARGB(255, 214, 163, 100),
                          Color.fromARGB(255, 248, 217, 173)
                        ]
                      )
                    ),
                    SizedBox(height: 4),
                    CustomText("21189/32400",
                      fontWeight: w_400,
                      fontSize: 12,
                      color: Colors.white
                    )
                  ]
                ),
                SizedBox(width: 18.5),
                Container(
                  width: 74,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 233, 184, 122),
                        Color.fromARGB(255, 248, 217, 173)
                      ]
                    )
                  ),
                  child: CustomText("立即升级",
                    color: Color.fromARGB(255, 192, 131, 0),
                    fontSize: 12,
                    fontWeight: w_bold
                  )
                ).gestureDetector(onTap: (){

                })
              ]
            ),
            SizedBox(height: 21),
            Text.rich(TextSpan(
              text: "VIP会员升级后",
              style: AppStyles.f12w400c255_255_255,
              children: [
                TextSpan(
                  text: "可获得如下奖励",
                  style: TextStyle(
                    color: Color.fromARGB(255, 243, 207, 158)
                  )
                )
              ]
            )),
            SizedBox(height: 15),
            Row(
              children: [
                Wrap(
                  // alignment: WrapAlignment.center,
                  spacing: 35,
                  children: _privilege.map((e) => Column(
                    children: [
                      Image.asset(e.image),
                      SizedBox(height: 4),
                      CustomText("${e.text}", style: AppStyles.f12w400c255_255_255)
                    ]
                  )).toList(),
                ).expanded()
              ]
            )
          ]
        )
      ),
      SizedBox(height: 50),
      Container(
        height: 155,
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 16
        ) + EdgeInsets.only(top: 6),
        width: this.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.5),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 97, 97, 97).withOpacity(0.08),
              offset: Offset(0, 6),
              blurRadius: 20
            )
          ]
        ),
        child: Column(
          children: [
            CustomText("如何升级",
              fontSize: 18,
              fontWeight: w_800,
              color: Color.fromARGB(255, 236, 189, 132)
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Wrap(
                  spacing: 55,
                  children: _upgrade.map((e) => Column(
                    children: [
                      Image.asset(e.image),
                      SizedBox(height: 4),
                      CustomText("${e.text}", style: AppStyles.f12wnormalc121_121_121.copyWith(
                        color: Color.fromARGB(255, 167, 167, 167)
                      ))
                    ]
                  )).toList()
                ).expanded()
              ]
            )
          ]
        )
      )
    ]
  );
}