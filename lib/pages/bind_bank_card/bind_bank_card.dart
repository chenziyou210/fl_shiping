/*
 *  Copyright (C), 2015-2021
 *  FileName: bind_bank_card
 *  Author: Tonight丶相拥
 *  Date: 2021/7/20
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';

class BindBankCardPage extends StatefulWidget {
  @override
  createState() => _BindBankCardPageState();
}

const double _rowHeight = 50.0;
class _BindBankCardPageState extends AppStateBase<BindBankCardPage> {
  
  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.bindBankCard, style: AppStyles.f17w400c0_0_0)
  );

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c244_244_244;

  @override
  // TODO: implement body
  Widget get body => Column(
    children: [
      SizedBox(height: 12),
      Container(
        color: AppColors.c255_255_255,
        padding: EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: Column(
          children: [
            SizedBox(
              height: _rowHeight,
              child: Row(
                  children: [
                    Text(intl.cardHolder, style: AppStyles.f14w400c0_0_0),
                    SizedBox(width: 8),
                    Expanded(child: CustomTextField(
                      textAlign: TextAlign.end,
                      hintText: intl.pleaseEnter1,
                      hintTextStyle: AppStyles.f14w400c0_0_0.copyWith(
                        color: AppColors.c0_0_0.withOpacity(0.4)
                      ),
                      style: AppStyles.f14w400c0_0_0
                    ))
                  ]
              )
            ),
            CustomDivider(
              height: 1,
              color: AppColors.c239_239_239
            ),
            SizedBox(
                height: _rowHeight,
                child: Row(
                    children: [
                      Text(intl.bankCardNumber, style: AppStyles.f14w400c0_0_0),
                      SizedBox(width: 8),
                      Expanded(child: CustomTextField(
                          textAlign: TextAlign.end,
                          hintText: intl.pleaseEnter1,
                          hintTextStyle: AppStyles.f14w400c0_0_0.copyWith(
                              color: AppColors.c0_0_0.withOpacity(0.4)
                          ),
                          style: AppStyles.f14w400c0_0_0
                      ))
                    ]
                )
            ),
            CustomDivider(
                height: 1,
                color: AppColors.c239_239_239
            ),
            SizedBox(
                height: _rowHeight,
                child: Row(
                    children: [
                      Text(intl.bankAccount, style: AppStyles.f14w400c0_0_0),
                      SizedBox(width: 8),
                      Expanded(child: CustomTextField(
                          textAlign: TextAlign.end,
                          hintText: intl.pleaseEnter1,
                          hintTextStyle: AppStyles.f14w400c0_0_0.copyWith(
                              color: AppColors.c0_0_0.withOpacity(0.4)
                          ),
                          style: AppStyles.f14w400c0_0_0
                      ))
                    ]
                )
            ),
            CustomDivider(
                height: 1,
                color: AppColors.c239_239_239
            ),
            SizedBox(
                height: _rowHeight,
                child: Row(
                    children: [
                      Text(intl.accountOpeningBranch, style: AppStyles.f14w400c0_0_0),
                      SizedBox(width: 8),
                      Expanded(child: CustomTextField(
                          textAlign: TextAlign.end,
                          hintText: intl.pleaseEnter1,
                          hintTextStyle: AppStyles.f14w400c0_0_0.copyWith(
                              color: AppColors.c0_0_0.withOpacity(0.4)
                          ),
                          style: AppStyles.f14w400c0_0_0
                      ))
                    ]
                )
            ),
            CustomDivider(
                height: 1,
                color: AppColors.c239_239_239
            )
          ]
        )
      ),
      SizedBox(height: 55),
      Text("（${intl.cannotBeModifiedAfterBinding}）", style: AppStyles.f14w400c0_0_0.copyWith(
        color: AppColors.c0_0_0.withOpacity(0.7)
      )),
      SizedBox(height: 12),
      InkWell(
          onTap: (){

          },
          child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(AppImages.confirmButton),
                Text(intl.bind, style: AppStyles.f15w500c255_255_255)
              ]
          )
      )
    ]
  );
} 