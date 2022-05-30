/*
 *  Copyright (C), 2015-2021
 *  FileName: withdraw
 *  Author: Tonight丶相拥
 *  Date: 2021/7/20
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'withdraw_model.dart';

class WithdrawPage extends StatefulWidget {

  @override
  createState() => _WithdrawPageState();
}

class _WithdrawPageState extends AppStateBase<WithdrawPage> {

  @override
  // TODO: implement model
  WithdrawModel get model => super.model as WithdrawModel;

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.withdraw, style: AppStyles.f17w400c0_0_0)
  );

  @override
  // TODO: implement resizeToAvoidBottomInset
  bool? get resizeToAvoidBottomInset => false;

  @override
  // TODO: implement body
  Widget get body => Container(
    width: this.width,
    child: Column(
        children: [
          SizedBox(height: 24),
          if (model.hasBankCard)
            _AddBankCard("+  " + intl.bindBankCard, onTap: (){
              pushViewControllerWithName(AppRoutes.bindBankCard);
            })
          else
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(intl.withdrawTo, style: AppStyles.f16w400c0_0_0),
                    SizedBox(height: 12),
                    InkWell(
                      child: Row(
                          children: [
                            Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                    color: AppColors.c165_59_227,
                                    borderRadius: BorderRadius.circular(11.5)
                                )
                            ),
                            SizedBox(width: 8),
                            Expanded(
                                child: Text("Bank card name", style: AppStyles.f18w400c0_0_0.copyWith(
                                    color: AppColors.c0_0_0.withOpacity(0.8)
                                ))
                            ),
                            Image.asset(AppImages.forwardGray)
                          ]
                      ),
                      onTap: (){

                      }
                    )
                  ]
              )
            ),
          SizedBox(height: 21),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13
            ) + EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.c255_255_255,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("${intl.withdraw + "  " + intl.amount}",
                        style: AppStyles.f14w400c0_0_0),
                    Spacer(),
                    Text(intl.amount100IsInteger, style: AppStyles.f14w400c125_125_125)
                  ]
                ),
                SizedBox(height: 19),
                Row(
                  children: [
                    Text("\$", style: AppStyles.f30w500c0_0_0.copyWith(
                      color: AppColors.c0_0_0.withOpacity(0.8)
                    )),
                    Expanded(child: CustomTextField(
                      inputFormatter: [
                        // OnlyInputInt(),
                        // FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      hintText: intl.pleaseEnter,
                      hintTextStyle: AppStyles.f24w400c0_0_0.copyWith(
                        color: AppColors.c0_0_0.withOpacity(0.4)
                      ),
                      style: AppStyles.f24w400c0_0_0
                    ))
                  ]
                ),
                CustomDivider(
                  color: AppColors.c239_239_239,
                  height: 1
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Column(
                        children: [
                          SelectorCustom<AppUser, double?>(
                              builder: (value) {
                                return Text.rich(TextSpan(
                                    text: intl.balance + "：",
                                    style: AppStyles.f14w400c125_125_125,
                                    children: [
                                      TextSpan(
                                          text: "$value",
                                          style: AppStyles.f14w400c0_0_0
                                      )
                                    ]
                                ));
                              }, selector: (a) => a.wallet),
                          Text.rich(TextSpan(
                              text: intl.codeAmount + "：",
                              style: AppStyles.f14w400c125_125_125,
                              children: [
                                TextSpan(
                                  text: "0",
                                  style: AppStyles.f14w400c0_0_0
                                )
                              ]
                          ))
                        ],
                      crossAxisAlignment: CrossAxisAlignment.start
                    )),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                          child: Text(intl.maximum, style: AppStyles.f16w500c106_69_255)
                      )
                    )
                  ]
                )
              ]
            )
          ),
          SizedBox(height: 25),
          InkWell(
            onTap: (){

            },
            child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(AppImages.confirmButton),
                  Text(intl.confirm, style: AppStyles.f15w500c255_255_255)
                ]
            )
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: 15
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(intl.withdrawInstructions, style: AppStyles.f14w400c0_0_0),
                SizedBox(height: 4),
                Text(intl.withdrawInstructionsContent, style: AppStyles.f12w400c0_0_0.copyWith(
                  color: AppColors.c0_0_0.withOpacity(0.69)
                ))
              ]
            )
          )
        ]
    )
  );

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c244_244_244;

  @override
  AppModel? initializeModel() {
    // TODO: implement initializeModel
    return WithdrawModel();
  }
}

class _AddBankCard extends StatelessWidget {
  _AddBankCard(this.text, {this.onTap});
  final String text;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        child: Container(
            width: 249,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: RDottedLineBorder.all(
                    color: AppColors.c151_151_151,
                    width: 1
                )
            ),
            child: Text(text,
                style: AppStyles.f20w400c0_0_0.copyWith(
                    color: AppColors.c0_0_0.withOpacity(0.4)
                )
            )
        ),
        onTap: onTap
    );
  }
}