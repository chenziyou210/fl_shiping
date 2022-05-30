/*
 *  Copyright (C), 2015-2021
 *  FileName: modify_password_base
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';

abstract class ModifyPasswordBaseLogic extends GetxController with Toast {
  Future<bool> changePassword({String? oldPassword, required String newPassword,
    required String confirmPassword});
}

abstract class ModifyPasswordBase<T extends StatefulWidget> extends AppStateBase<T> with Toast {
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  late final ModifyPasswordBaseLogic controller;

  String get title;

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("$title",
      fontSize: 16.pt,
      fontWeight: w_500,
      color: Color.fromARGB(255, 34, 40, 49)
    )
  );
  
  @override
  // TODO: implement body
  Widget get body => VisibleSingleScrollView(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText("$text1", style: _titleStyle),
            SizedBox(height: 8),
            Container(
              height: 65.pt,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: CustomTextField(
                controller: _oldController,
                hintTextStyle: _hintStyle,
                style: _style,
                obscureText: true,
                hintText: "${intl.oldPassword}"
              ),
            ),
            SizedBox(height: 16),
            CustomText("$text2", style: _titleStyle),
            SizedBox(height: 8),
            Container(
              height: 65.pt,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: CustomTextField(
                  controller: _newController,
                  hintTextStyle: _hintStyle,
                  style: _style,
                  obscureText: true,
                  hintText: "${intl.newPassword}"
              ),
            ),
            SizedBox(height: 16),
            CustomText("$text3", style: _titleStyle),
            SizedBox(height: 8),
            Container(
              height: 65.pt,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: CustomTextField(
                  controller: _confirmController,
                  hintTextStyle: _hintStyle,
                  style: _style,
                  obscureText: true,
                  hintText: "${intl.confirmPassword}"
              )
            ),
            SizedBox(height: 66.pt),
            Container(
              height: 60.pt,
              width: 248.pt,
              alignment: Alignment.center,
              child: CustomText("${intl.complete}",
               fontSize: 16.pt,
               fontWeight: w_bold,
               color: Colors.white
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.pt),
                gradient: LinearGradient(colors: AppColors.buttonGradientColors)
              ),
            ).cupertinoButton(
              onTap: onTap,
              miniSize: 60.pt
            ).center
          ]
        )
      )
    ],
    needBounds: false
  );

  final TextStyle _titleStyle = TextStyle(
    fontSize: 16.pt,
    fontWeight: w_400,
    color: Color.fromARGB(255, 34, 34, 44)
  );

  final TextStyle _hintStyle = TextStyle(
    fontSize: 17.pt,
    fontWeight: w_500,
    color: Color.fromARGB(255, 176, 176, 180)
  );

  final TextStyle _style = TextStyle(
    fontSize: 17.pt,
    fontWeight: w_500,
    color: Color.fromARGB(255, 34, 34, 44)
  );

  String get text1;
  String get text2;
  String get text3;

  void onTap() async{
    String text1 = _oldController.text;
    String text2 = _newController.text;
    String text3 = _confirmController.text;
    if (text2.isEmpty) {
      showToast("${intl.pleaseEnter} ${intl.newPassword}");
      return;
    }
    if (text3 != text2) {
      showToast("${intl.twoPasswordIsNotSame}");
      return;
    }
    show();
    var value = await controller.changePassword(oldPassword: text1.isEmpty ? null : text1,
        newPassword: text2, confirmPassword: text2);
    if (value){
      showToast("${intl.modifyPasswordSuccess}");
      popViewController();
    }
      // dismiss();
  }
}