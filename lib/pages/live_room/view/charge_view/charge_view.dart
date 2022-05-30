/*
 *  Copyright (C), 2015-2022
 *  FileName: charge_view
 *  Author: Tonight丶相拥
 *  Date: 2022/4/15
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

class LiveChargeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var intl = AppInternational.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 23, 35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(15))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          CustomText(intl.rechargeReBate, fontSize: 16,
            fontWeight: w_600,
            color: Colors.white),
          SizedBox(height: 8),
          Image.asset(AppImages.liveCharge, width: double.infinity,
            fit: BoxFit.fill).gestureDetector(onTap: (){

          })
        ]
      )
    );
  }
}

class LiveChargeView1 extends AlertDialog {
  LiveChargeView1({this.onTap, this.onCharge, required this.url});
  final VoidCallback? onTap;
  final VoidCallback? onCharge;
  final String url;
  @override
  // TODO: implement backgroundColor
  Color? get backgroundColor => Colors.transparent;

  @override
  // TODO: implement elevation
  double? get elevation => 0;

  @override
  // TODO: implement contentPadding
  EdgeInsetsGeometry get contentPadding => EdgeInsets.zero;

  @override
  // TODO: implement insetPadding
  EdgeInsets get insetPadding => EdgeInsets.zero;

  @override
  // TODO: implement content
  Widget? get content => Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 320),
          child: Image.asset(AppImages.chargeBackground)
        ),
        Container(
          // height: 200,
          width: 260,
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: url
          ),
          color: Color.fromARGB(255, 255, 225, 207),//255, 225, 207
        ).position(bottom: 80, top: 170),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(AppImages.chargeButton),
            CustomText(AppInternational.current.goToCharge,
              fontSize: 16, fontWeight: w_500,
              color: Colors.white
            )
          ]
        ).cupertinoButton(
          onTap: onCharge
        ).position(bottom: 20),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white)
          ),
          child: Image.asset(AppImages.livingClose),
        ).cupertinoButton(onTap: onTap).position(right: 8, top: 30)
      ]
  );
}