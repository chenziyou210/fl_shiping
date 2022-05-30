/*
 *  Copyright (C), 2015-2021
 *  FileName: withdraw_new
 *  Author: Tonight丶相拥
 *  Date: 2021/11/30
 *  Description: 
 **/


import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/bank_list_entity.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'withdraw_new_logic.dart';
import 'setting_pay_password.dart';

class WithDrawNew extends StatefulWidget {
  @override
  createState()=> _WithDrawNewState();
}

class _WithDrawNewState extends AppStateBase<WithDrawNew> {

  late Future _future;
  final WithdrawLogic _controller = WithdrawLogic();
  final TextEditingController _moneyController = TextEditingController();
  final FocusNode _moneyNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordNode = FocusNode();
  final TextStyle _style = TextStyle(
    fontSize: 14, fontWeight: w_400,
    color: Colors.white
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controller);
    _future = _controller.getData();
    if (AppManager.getInstance<AppUser>().withdrawIsNull)
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      alertViewController(SettingPayPassword((value){
        popViewController();
        if (!value) popViewController();
      }, intl));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<WithdrawLogic>();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    backgroundColor: Colors.transparent,
    leading: CustomBackButton(
      iconColor: Colors.white
    ),
    title: CustomText("${intl.withdraw}", fontSize: 16,
      fontWeight: w_500,
      color: Colors.white),
    actions: [
      TextButton(
        onPressed: (){
          pushViewControllerWithName(AppRoutes.withdrawRecord);
        }, 
        child: CustomText("${intl.record}",
          fontSize: 16,
          fontWeight: w_500,
          color: Colors.white
        ))
    ]
  );

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement resizeToAvoidBottomInset
  bool? get resizeToAvoidBottomInset => false;

  @override
  // TODO: implement body
  Widget get body => LoadingWidget(builder: (_, __) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(AppImages.withDrawBackground1,
                width: this.width,
                height: 325,
                fit: BoxFit.fill).container(),
              SafeArea(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx((){
                        if (_controller.state.data.length <= 0)
                          return SizedBox();
                        var bank = _controller.state.data[0];
                        return Row(
                          children: [
                            ExtendedImage.network(bank.bankIcon ?? "",
                                enableLoadState: false,
                                width: 40, height: 40,
                                fit: BoxFit.cover
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText("${bank.bankname}", style: _style),
                                SizedBox(height: 4),
                                CustomText("${bank.cardNumber}", style: _style)
                              ]
                            ).flexible
                          ]
                        );
                      }).expanded(),
                      SizedBox(width: 16),
                      TextButton(
                        onPressed: (){
                          pushViewControllerWithName(AppRoutes.bindBankManger, arguments: {
                            "lastPageIsWithdraw": true
                          }).then((value) {
                            if (value != null && value is BankListEntity) {
                              _controller.setData(value);
                            }
                          });
                        },
                        child: Obx((){
                          bool hasData = _controller.state.data.length > 0;
                          return CustomText("${hasData ? intl.changeAccount : intl.addBank}",
                              fontSize: 14,
                              fontWeight: w_500,
                              color: Colors.white);
                        }))
                    ]
                  ),
                  SizedBox(height: 32),
                  CustomText("${intl.amount}",
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: w_bold),
                  SizedBox(height: 8),
                  SelectorCustom<AppUser, double?>(
                    builder: (value) {
                      return CustomText(
                        "￥${value!.toStringAsFixed(2)}",
                        fontSize: 32,
                        fontWeight: w_bold,
                        color: Colors.white
                      );
                    },
                    selector: (a) => a.lockMoney,
                  ),
                  SizedBox(height: 8),
                  CustomDivider(color: Colors.white),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Image.asset(AppImages.withdrawWallet),
                      SizedBox(width: 8),
                      SelectorCustom<AppUser, double?>(builder: (value) {
                        return RichText(text: TextSpan(
                            text: "${intl.availableWithdrawMoney}: ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: w_500,
                                color: Colors.white
                            ),
                            children: [
                              TextSpan(text: "$value", style: TextStyle(
                                color: Color.fromARGB(255, 254, 182, 51)
                              ))
                            ]
                        ));
                      }, selector: (a) => a.coins)
                    ]
                  )
                ]
              ), bottom: false).paddingOnly(
                top: 8
              ).paddingSymmetric(horizontal: 16)
            ],
          ),
          SizedBox(height: 16),
          [Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("${intl.withdraw}",
                  fontWeight: w_500, fontSize: 16,
                  color: Colors.black),
                SizedBox(
                  height: 8
                ),
                _BorderContainer(
                    child: [CustomTextField(
                      controller: _moneyController,
                      node: _moneyNode,
                      prefixIcon: CustomText("￥", fontWeight: w_500,
                        color: Colors.black, fontSize: 16).container(
                        padding: EdgeInsets.only(right: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(
                            color: Colors.black12
                          ))
                        )
                      ),
                      inputFormatter: [OnlyInputInt()],
                      hintText: "${intl.enterWithdrawMoney}",
                      style: TextStyle(
                          fontWeight: w_400,
                          fontSize: 17
                      ),
                      hintTextStyle: TextStyle(
                          color: Color.fromARGB(255, 196, 196, 196),
                          fontWeight: w_400,
                          fontSize: 17
                      ),
                    ).sampleVisibleEnsure(_moneyNode).flexible,
                       Container(
                         width: 52,
                         height: 40,
                         decoration: BoxDecoration(
                           color: Color.fromARGB(255, 34, 40, 49),
                           borderRadius: BorderRadius.circular(8)
                         ),
                         alignment: Alignment.center,
                         child: CustomText(
                           "${intl.all}",
                           fontSize: 16,
                           fontWeight: w_500,
                           color: Colors.white
                         ),
                       ).gestureDetector(onTap: (){
                         var user = AppManager.getInstance<AppUser>();
                         if (user.coins != null)
                           _moneyController.text = user.coins.toString().split(".")[0];
                       })
                    ].row()
                ),
                SizedBox(height: 16),
                CustomText("${intl.withdrawPassword}", 
                  fontWeight: w_500, fontSize: 16,
                  color: Colors.black),
                SizedBox(height: 4),
                _BorderContainer(
                  child: CustomTextField(
                    obscureText: true,
                    node: _passwordNode,
                    controller: _passwordController,
                    prefixIcon: Image.asset(AppImages.withdrawLock).container(
                        padding: EdgeInsets.only(right: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(right: BorderSide(
                                color: Colors.black12
                            ))
                        )
                    ),
                    hintText: "${intl.enter} ${intl.withdrawPassword}",
                    style: TextStyle(
                        fontWeight: w_400,
                        fontSize: 17
                    ),
                    hintTextStyle: TextStyle(
                        color: Color.fromARGB(255, 196, 196, 196),
                        fontWeight: w_400,
                        fontSize: 17
                    ),
                  ).sampleVisibleEnsure(_passwordNode)
                ).container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 244),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 232, 232, 232).withOpacity(0.25),
                        offset: Offset(15, 20),
                        blurRadius: 45
                      )
                    ]
                  )
                )
              ]
            )
          ),
          SizedBox(height: 32),
          Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 34, 40, 49),
              borderRadius: BorderRadius.circular(23)
            ),
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: CustomText("${intl.confirm}", 
              fontSize: 16, fontWeight: w_500,
              color: Colors.white)
          ).gestureDetector(
            onTap: (){
              _controller.withdraw(_moneyController.text, _passwordController.text);
            }
          )].column().visibleSingleScrollView(
           scrollPhysics: ClampingScrollPhysics()).expanded()
        ]
      )
    );
  }, future: _future);
}

class _BorderContainer extends StatelessWidget {
  _BorderContainer({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: 65,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color.fromARGB(255, 231, 231, 231))
        ),
        child: child
    );
  }
}