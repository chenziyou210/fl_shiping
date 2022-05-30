/*
 *  Copyright (C), 2015-2021
 *  FileName: forget_password
 *  Author: Tonight丶相拥
 *  Date: 2021/12/7
 *  Description: 
 **/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/pages/register/image_code_view.dart';
import 'forget_password_logic.dart';

class ForgetPassword extends StatefulWidget {
  @override
  createState()=> _ForgetPasswordState();
}

class _ForgetPasswordState extends AppStateBase<ForgetPassword> with Toast {
  /// 数据控制
  final ForgetPasswordLogic _controller = ForgetPasswordLogic();

  /// 输入框
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _verifyCode = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final FocusNode _newPasswordNode = FocusNode();
  final TextEditingController _confirmPassword = TextEditingController();
  final FocusNode _confirmPasswordNode = FocusNode();

  /// 样式
  final TextStyle _style = TextStyle(
    color: Color.fromARGB(255, 34, 34, 44),
    fontSize: 17.pt,
    fontWeight: w_500
  );
  final TextStyle _hintStyle = TextStyle(
    fontSize: 17.pt,
    fontWeight: w_500,
    color: Color.fromARGB(255, 176, 176, 180)
  );
  final InputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 238, 238, 238)
    )
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ForgetPasswordLogic>();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    backgroundColor: Colors.transparent
  );

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement body
  Widget get body => [
    Image.asset(AppImages.getBackPasswordHeader,
      width: this.width, fit: BoxFit.fill),
    VisibleSingleScrollView(
    crossAxisAlignment: CrossAxisAlignment.start,
    needBounds: false,
    children: [
      SizedBox(height: 44.pt),
      CustomText("${intl.retrievePassword}",
        fontSize: 31.pt,
        fontWeight: w_600,
        color: Color.fromARGB(255, 34, 34, 44)
      ),
      SizedBox(height: 40),
      CustomText("${intl.phoneNumber}", fontSize: 16.pt,
        fontWeight: w_400, color: Color.fromARGB(255, 34, 34, 44)
      ),
      SizedBox(height: 4),
      CustomTextField(
        controller: _phoneNumber,
        hintText: "${intl.pleaseEnterPhoneNumber}",
        hintTextStyle: _hintStyle,
        style: _style,
        border: _border,
        suffixIcon: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            width: 57.pt,
            height: 57.pt,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                colors: AppColors.buttonGradientColors)
            ),
            alignment: Alignment.center,
            child: CustomText("${intl.send}",
              fontSize: 16.pt,
              fontWeight: w_500,
              color: Colors.white
            ),
          ), onPressed: (){

          var text = _phoneNumber.text;
          if (text.isEmpty){
            showToast("${intl.pleaseEnterPhoneNumber}");
            return;
          }
          showDialog(context: context, builder: (_) {
            return VerificationCodeAlter(
                imageVerification: intl.imageVerification,
                confirm: intl.confirm,
                refresh: intl.refresh,
                hintText: "${intl.pleaseEnterVerificationCode}",
                onConfirm: (value){
                  popViewController();
                  _controller.sendCode(account: text, verifyCode: value);
                },
                onUuidChange: (uid) {
                  _controller.setUid(uid);
                }
            );
          });
        }),
        textAlignVertical: TextAlignVertical.center,
        suffixIconConstraints: BoxConstraints(
          minWidth: 65.pt,
          minHeight: 65.pt
        )
      ),
      SizedBox(height: 24.pt),
      CustomText("${intl.verifyCode}", fontSize: 16.pt,
        fontWeight: w_400, color: Color.fromARGB(255, 34, 34, 44)),
      SizedBox(height: 4),
      CustomTextField(
        controller: _verifyCode,
        hintText: "${intl.pleaseEnterVerificationCode}",
        hintTextStyle: _hintStyle,
        style: _style,
        border: _border
      ),
      SizedBox(height: 24.pt),
      CustomText("${intl.newPassword}", fontSize: 16.pt,
        fontWeight: w_400, color: Color.fromARGB(255, 34, 34, 44)),
      SizedBox(height: 4),
      CustomTextField(
        controller: _newPassword,
        hintText: "${intl.pleaseEnterPassword}",
        hintTextStyle: _hintStyle,
        style: _style,
        border: _border,
        node: _newPasswordNode,
        obscureText: true
      ).sampleVisibleEnsure(_newPasswordNode),
      SizedBox(height: 24.pt),
      CustomText("${intl.confirmPassword}", fontSize: 16.pt,
          fontWeight: w_400, color: Color.fromARGB(255, 34, 34, 44)),
      SizedBox(height: 4),
      CustomTextField(
          controller: _confirmPassword,
          hintText: "${intl.pleaseConfirmPassword}",
          hintTextStyle: _hintStyle,
          style: _style,
          border: _border,
          obscureText: true,
          node: _confirmPasswordNode
      ).sampleVisibleEnsure(_confirmPasswordNode),
      SizedBox(height: 43.pt),
      CupertinoButton(child: Container(
        width: 248.pt,
        height: 60.pt,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.pt),
          gradient: LinearGradient(colors: AppColors.buttonGradientColors)
        ),
        alignment: Alignment.center,
        child: CustomText("${intl.complete}",
          fontSize: 16.pt,
          fontWeight: w_bold,
          color: Colors.white
        )
      ), onPressed: () async{
        var phoneNumber = _phoneNumber.text;
        var code = _verifyCode.text;
        var password = _newPassword.text;
        var confirmPassword = _confirmPassword.text;
        if(phoneNumber.isEmpty) {
          showToast("${intl.pleaseEnterPhoneNumber}");
          return;
        }
        if(code.isEmpty) {
          showToast("${intl.pleaseEnterVerificationCode}");
          return;
        }
        if(password.isEmpty) {
          showToast("${intl.pleaseEnterPassword}");
          return;
        }
        if(confirmPassword.isEmpty) {
          showToast("${intl.pleaseConfirmPassword}");
          return;
        }
        if (password != confirmPassword) {
          showToast("${intl.twoPasswordIsNotSame}");
          return;
        }
        var result = await _controller.forgetPassword(phoneNumber: phoneNumber, code: code,
            password: password, rePassword: confirmPassword);
        if (result) {
          popViewController({
            "account": phoneNumber,
            "password": password
          });
        }
      }, padding: EdgeInsets.zero).center,
      SizedBox(height: 48.pt)
    ]
  ).padding(padding: EdgeInsets.symmetric(
    horizontal: 24.pt
  )).expanded()].column();
}