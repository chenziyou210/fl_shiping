/*
 *  Copyright (C), 2015-2021
 *  FileName: diamond_recharge
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
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/diamond_charge_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';

class DiamondRechargePage extends StatefulWidget {
  @override
  createState()=> _DiamondRechargePageState();
}

class _DiamondRechargePageState extends AppStateBase<DiamondRechargePage> with Toast {

  late Future _future;
  List<DiamondChargeEntity> _diamond = [];
  double? _remainedDiamond = 0;
  double? _balance = 0;

  int? _index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = HttpChannel.channel.showConsPage()..then((value) =>
      value.finalize(
        wrapper: WrapperModel(),
        failure: (e) => showToast(e),
        success: (data) {
          List lst = data["rechargeList"] ?? [];
          _remainedDiamond = data["diamond"] ?? 0;
          _balance = data["balance"] ?? 0;
          _diamond = lst.map((e) => DiamondChargeEntity.fromJson(e)).toList();
        }
      ));
  }
  
  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.wallet, style: AppStyles.f17w400c0_0_0),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 13),
        child: Center(
          child: GestureDetector(
            onTap: (){
              
            },
            child: Image.asset(AppImages.customerService)
          )
        ),
      )
    ]
  );

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c255_255_255;

  @override
  Widget get body => LoadingWidget(builder: (_, __) {
    return body1;
  }, future: _future);

  Widget get body1 => Column(
    children: [
      Container(
        height: 38,
        color: AppColors.c255_244_243,
        padding: EdgeInsets.symmetric(horizontal: 13),
        child: Row(
          children: [
            Image.asset(AppImages.prompt),
            SizedBox(width: 8),
            Text(intl.recommendYouToUseABackCardToPay, style: AppStyles.f13w400c249_102_87)
          ]
        )
      ),
      SizedBox(
        width: this.width,
        height: 192,
        child: Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              Positioned(
                  child: Image.asset(AppImages.diamondRechargeBackground,
                      fit: BoxFit.fill),
                  left: -14,
                  right: -14
              ),
              Positioned(child: Row(
                children: [
                  Image.asset(AppImages.diamond),
                  SizedBox(width: 11),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Row(
                            children: [
                              Column(
                                  children: [
                                    Text("$_balance", style: AppStyles.f24wboldc249_102_87),
                                    SizedBox(height: 6),
                                    Text(intl.balance, style: AppStyles.f14w400c249_102_87)
                                  ]
                              ),
                              SizedBox(width: 84),
                              Column(
                                  children: [
                                    Text("$_remainedDiamond", style: AppStyles.f24wboldc249_102_87),
                                    SizedBox(height: 6),
                                    Text(intl.diamond, style: AppStyles.f14w400c249_102_87)
                                  ]
                              )
                            ]
                        ),
                        SizedBox(height: 18),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 48),
                          height: 35,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17.5),
                            color: AppColors.c249_102_87,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                spreadRadius: 0,
                                color: AppColors.c167_167_167.withOpacity(0.5)
                              )
                            ]
                          ),
                          child: Text(intl.recharge, style: AppStyles.f14w400c255_255_255)
                        ).gestureDetector(
                            onTap: (){
                              if (_index == null){
                                return;
                              }
                              var model = _diamond[_index!];
                              show();
                              HttpChannel.channel.chargeDiamond(model.id!).then((value) =>
                                value.finalize(
                                  wrapper: WrapperModel(),
                                  failure: (e) => showToast(e),
                                  success: (_) {
                                    dismiss();
                                    AppManager.getInstance<AppUser>().chargeDiamond(model.amount!);
                                    this._balance = _balance! - model.amount!;
                                    this._remainedDiamond = this._remainedDiamond! + model.diamond!;
                                    setState(() {});
                                  }
                                ));
                            })
                      ]
                  ))
                ]
              ), left: 0, right: 0),
            ]
        )
      ),
      Expanded(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                mainAxisExtent: 78,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16
            ),
            itemCount: _diamond.length,
            itemBuilder: (_, index) {
              var model = _diamond[index];
              return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.c246_136_52.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(4),
                    border: _index != null && index == _index ? Border.all(color: Colors.red) : null
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${model.diamond}", style: AppStyles.f20w600c249_102_87),
                        SizedBox(height: 6),
                        Text("\$${model.amount}", style: AppStyles.f16c165_165_165)
                      ]
                  )
              ).gestureDetector(onTap: (){
                _index = index;
                updateState();
              });
            })
      ))
    ]
  ).nullWidget<List>(_diamond, predict: (data) => data.length == 0);
}