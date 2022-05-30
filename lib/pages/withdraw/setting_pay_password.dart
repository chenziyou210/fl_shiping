/*
 *  Copyright (C), 2015-2021
 *  FileName: setting_pay_password
 *  Author: Tonight丶相拥
 *  Date: 2021/12/31
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';

class SettingPayPassword extends AlertDialog with Toast {
  SettingPayPassword(this.onTap, this.intl);
  final void Function(bool) onTap;
  final AppInternational intl;
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final TextStyle _hintStyle = TextStyle(
      fontSize: 14.pt,
      fontWeight: w_500,
      color: Color.fromARGB(255, 176, 176, 180)
  );

  final TextStyle _style = TextStyle(
      fontSize: 14.pt,
      fontWeight: w_500,
      color: Color.fromARGB(255, 34, 34, 44)
  );

  @override
  // TODO: implement content
  Widget? get content => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 24.pt, width: 320.pt),
        CustomText("${intl.setPayPassword}",
            fontSize: 16.pt,
            fontWeight: w_500,
            color: Colors.black
        ),
        SizedBox(height: 36.pt),
        Container(
          height: 65.pt,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 244),
              borderRadius: BorderRadius.circular(10)
          ),
          child: CustomTextField(
              controller: _password,
              hintTextStyle: _hintStyle,
              style: _style,
              obscureText: true,
              hintText: "${intl.setPayPassword}"
          ),
        ),
        SizedBox(height: 22.pt),
        Container(
          height: 65.pt,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 244),
              borderRadius: BorderRadius.circular(10)
          ),
          child: CustomTextField(
              controller: _confirmPassword,
              hintTextStyle: _hintStyle,
              style: _style,
              obscureText: true,
              hintText: "${intl.confirmPassword}"
          ),
        ),
        SizedBox(height: 39.pt)
      ]
  );

  @override
  // TODO: implement actions
  List<Widget>? get actions => [
    Container(
      height: 46.pt,
      width: 320.pt,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23.pt),
          gradient: LinearGradient(
              colors: AppColors.buttonGradientColors
          )
      ),
      alignment: Alignment.center,
      child: CustomText("${intl.confirm}", fontSize: 16.pt,
          fontWeight: w_500, color: Colors.white),
    ).cupertinoButton(
        onTap: (){
          var text1 = _password.text;
          var text2 = _confirmPassword.text;
          if (text1.isEmpty && text2.isEmpty) {
            onTap(false);
          }else {
            if (text1.isEmpty) {
              showToast("${intl.pleaseEnterPassword}");
              return;
            }else if (text1 != text2) {
              showToast("${intl.twoPasswordIsNotSame}");
              return;
            }
            show();
            HttpChannel.channel.modifyWithdrawPassword(newPassword: text1,
                confirmNewPassword: text2).then((value) {
              return value.finalize(
                  wrapper: WrapperModel(),
                  failure: (e){
                    showToast(e);
                    onTap(false);
                  },
                  success: (_){
                    dismiss();
                    onTap(true);
                  }
              );
            });
          }
        }
    )
  ];

  @override
  // TODO: implement contentPadding
  EdgeInsetsGeometry get contentPadding => EdgeInsets.symmetric(horizontal: 16);

  @override
  // TODO: implement insetPadding
  EdgeInsets get insetPadding => EdgeInsets.zero;
}