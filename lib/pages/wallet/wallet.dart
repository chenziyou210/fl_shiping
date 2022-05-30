/*
 *  Copyright (C), 2015-2021
 *  FileName: wallet
 *  Author: Tonight丶相拥
 *  Date: 2021/7/13
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'wallet_model.dart';
import 'views/bank_recharge.dart';
import 'views/customer_service_recharge.dart';
import 'views/recharge_fourth.dart';

class WalletPage extends StatefulWidget {
  @override
  createState()=> _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // future = HttpChannel.channel.systemParameter().then((value)
    //   => value.finalize(wrapper: WrapperModel()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Scaffold(
        appBar: DefaultAppBar(
          leading: SizedBox(),
          automaticallyImplyLeading: false,
        ),
        body: SelectorCustom<SettingViewModel, String?>(builder: (String? value) {
          if (value == null)
            return SizedBox();
          return WebView(
              initialUrl: value
          );
        }, selector:(s) => s.url1)
    );
  }
}


class WalletPage1 extends StatefulWidget {
  @override
  createState() => _WalletPageState1();
}

class _WalletPageState1 extends AppStateBase<WalletPage1>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  late final TabController _controller;

  final int _length = 4;

  @override
  // TODO: implement model
  WalletModel get model => super.model as WalletModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: _length, vsync: this,
        initialIndex: model.viewModel.index)..addListener(() {
      if (_controller.indexIsChanging) {
        model.changeIndex(_controller.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return ChangeNotifierProvider.value(value: model.viewModel,
        child: scaffold);
  }

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c255_255_255;

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    automaticallyImplyLeading: false,
    leading: SizedBox(),
    backgroundColor: Colors.transparent,
    title: Text(intl.recharge, style: AppStyles.f17w400c255_255_255),
    actions: [
      GestureDetector(
        onTap: (){

        },
        child: Image.asset(AppImages.customServiceWhite)
      )
    ]
  );

  @override
  // TODO: implement body
  Widget get body => Column(
    children: [
      Stack(
        children: [
          Image.asset(AppImages.rechargeBackground,
              width: this.width, height: 237,
              fit: BoxFit.fill),
          Positioned(child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 32),
                    Column(
                      children: [
                        Text("544", style: AppStyles.f30c255_225_0),
                        SizedBox(height: 4),
                        Text(intl.balance, style: AppStyles.f16w400c255_255_255)
                      ]
                    ),
                    SizedBox(width: 52),
                    Column(
                      children: [
                        Text("23", style: AppStyles.f30c255_225_0),
                        SizedBox(height: 4),
                        Text(intl.diamond, style: AppStyles.f16w400c255_255_255)
                      ]
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(AppImages.exchangeOrange),
                          Positioned(
                            child: Text(intl.exchange,
                                style: AppStyles.f14w400c255_255_255),
                            right: 4
                          )
                        ]
                      )
                    )
                  ]
                ),
                SizedBox(height: 22),
                SelectorCustom<WalletViewModel, int>(
                    builder: (selectIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(_length, (index) {
                          BoxDecoration decoration = BoxDecoration(
                            color: AppColors.c244_244_244
                          );
                          bool atIndex = index == selectIndex;

                          if (index == selectIndex){
                            decoration = decoration.copyWith(
                                color: AppColors.c255_255_255,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(6))
                            );
                          }

                          if (index == 0 && !atIndex) {
                            decoration = decoration.copyWith(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6))
                            );
                          }else if (index == _length - 1 && !atIndex){
                            decoration = decoration.copyWith(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(6))
                            );
                          }
                          var item = GestureDetector(
                              onTap: (){
                                if (index != model.viewModel.index) {
                                  model.changeIndex(index);
                                  _controller.animateTo(index);
                                }
                              },
                              child: Container(
                                  width: 87,
                                  height: selectIndex == index ? 59 : 49,
                                  decoration: decoration
                              )
                          );

                          if (index != _length - 1)
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                item,
                                Container(
                                  width: 1,
                                  height: 49,
                                  color: AppColors.c229_229_229
                                )
                              ]
                            );

                          return item;
                        })
                      );
                    }, selector: (vm) => vm.index)
              ]
            )
          ), bottom: 0, left: 0, right: 0)
        ]
      ),
      Container(
        height: 38,
        padding: EdgeInsets.symmetric(
          horizontal: 15
        ),
        color: AppColors.c165_59_227.withOpacity(0.05),
        width: double.infinity,
        child: Row(
          children: [
            Image.asset(AppImages.recommend),
            SizedBox(width: 4),
            Text(intl.recommendYouToUseABackCardToPay,
                style: AppStyles.f13w400c165_59_227)
          ]
        )
      ),
      Expanded(child: TabBarView(children: [
        BankRechargeView(),
        CustomServiceRecharge(),
        Container(child: Text("3333")),
        RechargeFourth()
        // Container(child: Text("4444"))
      ], controller: _controller,
         physics: NeverScrollableScrollPhysics()))
    ]
  );

  @override
  AppModel? initializeModel() {
    // TODO: implement initializeModel
    return WalletModel();
  }
}