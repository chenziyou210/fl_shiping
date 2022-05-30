/*
 *  Copyright (C), 2015-2021
 *  FileName: wallet_detail
 *  Author: Tonight丶相拥
 *  Date: 2021/7/19
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';

class WalletDetailPage extends StatefulWidget {
  @override
  createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends AppStateBase<WalletDetailPage> {
  final Size _buttonSize = Size(125, 35);
  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.wallet, style: AppStyles.f17w400c0_0_0)
  );

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c243_243_243;

  @override
  // TODO: implement body
  Widget get body => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      horizontal: 13
    ),
    child: Column(
      children: [
        SizedBox(height: 14),
        Stack(
          children: [
            Image.asset(AppImages.balanceBackground),
            Positioned(child: Container(
              child: InkWellRow(children: [
                Text(intl.recording, style: AppStyles.f16w400c255_255_255),
                SizedBox(width: 6),
                Image.asset(AppImages.forwardWhite)
              ])
            ), right: 27, top: 14),
            Positioned(child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(intl.balance, style: AppStyles.f14w400c255_255_255),
                      SizedBox(width: 22),
                      SelectorCustom<AppUser, double?>(
                        builder: (value) {
                          return Text("$value", style: AppStyles.f24wboldc255_255_255);
                        }, selector: (a)=> a.coins)
                    ]
                  )
                ),
                SizedBox(height: 27),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        pushViewControllerWithName(AppRoutes.chargePage);
                        // pushViewControllerWithName(AppRoutes.diamondRecharge);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.c255_255_255,
                              borderRadius: BorderRadius.circular(_buttonSize.height / 2)
                          ),
                          width: _buttonSize.width,
                          height: _buttonSize.height,
                          child: Text(intl.recharge, style: AppStyles.f14w400c42_208_199)
                      )
                    ),
                    SizedBox(width: 35),
                    InkWell(
                      onTap: (){
                        pushViewControllerWithName(AppRoutes.withdrawNew);
                        // pushViewControllerWithName(AppRoutes.withdraw);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_buttonSize.height / 2),
                              border: Border.all(
                                  color: AppColors.c255_255_255,
                                  width: 1
                              )
                          ),
                          width: _buttonSize.width,
                          height: _buttonSize.height,
                          child: Text(intl.withdraw, style: AppStyles.f14w400c255_255_255)
                      )
                    )
                  ]
                )
              ]
            ), left: 32, bottom: 30, right: 32)
          ]
        ),
        SizedBox(
          height: 16
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(AppImages.diamondBackground),
            Column(
              children: [
                Text("0.0", style: AppStyles.f24wboldc255_255_255),
                SizedBox(height: 4),
                Text(intl.myDiamond, style: AppStyles.f14w400c255_255_255),
                SizedBox(height: 18),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_buttonSize.height / 2),
                      border: Border.all(
                          color: AppColors.c255_255_255,
                          width: 1
                      )
                  ),
                  width: _buttonSize.width,
                  height: _buttonSize.height,
                  child: Text(intl.exchange, style: AppStyles.f14w400c255_255_255)
                ).gestureDetector(onTap: (){
                  // pushViewControllerWithName(AppRoutes.diamondRecharge);
                }),
                SizedBox(height: 4)
              ]
            )
          ]
        ),
        SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(AppImages.sendOutBackground),
            Column(
              children: [
                Text("0.0", style: AppStyles.f24wboldc255_255_255),
                SizedBox(height: 18),
                Text(intl.sendOut, style: AppStyles.f14w400c255_255_255),
                SizedBox(height: 11)
              ]
            )
          ]
        )
      ]
    )
  );
}