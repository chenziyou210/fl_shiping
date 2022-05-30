/*
 *  Copyright (C), 2015-2021
 *  FileName: register
 *  Author: Tonight丶相拥
 *  Date: 2021/10/13
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import '../login/login.dart';
import 'register_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  createState()=> _RegisterPageState();
}

class _RegisterPageState extends LogInPageState<RegisterPage> {

  final ScrollController controller = ScrollController();

  /// 账号
  final TextEditingController _accountController = TextEditingController();
  final FocusNode _accountNode = FocusNode();

  /// 密码
  final TextEditingController _secretController = TextEditingController();
  final FocusNode _secretNode = FocusNode();

  /// 密码
  final TextEditingController _reSecretController = TextEditingController();
  final FocusNode _reSecretNode = FocusNode();

  final RegisterModel model = RegisterModel();

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    backgroundColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return scaffold;
  }

  @override
  // TODO: implement body1
   Widget get body1 => Positioned.fill(
     child: VisibleSingleScrollView(
       scrollPhysics: ClampingScrollPhysics(),
       children: [
         Spacer(),
         SampleVisibleEnsure(_accountNode, child: SizedBox(
           child: [
             CustomTextField(
                 style: AppStyles.f14w400c255_255_255,
                 hintText: intl.pleaseInputAccount,
                 hintTextStyle: AppStyles.f14w400c255_255_255,
                 prefixIcon: Image.asset(AppImages.logInAccount),
                 controller: _accountController,
                 node: _accountNode
             ),
             SizedBox(
               width: this.width / 3 * 2,
               child: CustomDivider(
                   height: 1,
                   color: AppColors.c255_255_255
               ),
             )
           ].column(),
           width: this.width / 3 * 2,
         )),
         SizedBox(height: 30),
         SampleVisibleEnsure(_secretNode, child: SizedBox(
           child: [CustomTextField(
               obscureText: true,
               hintText: intl.pleaseInputPassword,
               hintTextStyle: AppStyles.f14w400c255_255_255,
               style: AppStyles.f14w400c255_255_255,
               prefixIcon: Image.asset(AppImages.logInPassword),
               controller: _secretController,
               node: _secretNode
           ),
             SizedBox(
               width: this.width / 3 * 2,
               child: CustomDivider(
                   height: 1,
                   color: AppColors.c255_255_255
               ),
             )
           ].column(),
           width: this.width / 3 * 2,
         )),
         SizedBox(height: 30),
         SampleVisibleEnsure(_reSecretNode, child: SizedBox(
           child: [CustomTextField(
               obscureText: true,
               style: AppStyles.f14w400c255_255_255,
               hintText: intl.pleaseInputPassword,
               hintTextStyle: AppStyles.f14w400c255_255_255,
               prefixIcon: Image.asset(AppImages.logInPassword),
               controller: _reSecretController,
               node: _reSecretNode
           ),
             SizedBox(
               width: this.width / 3 * 2,
               child: CustomDivider(
                   height: 1,
                   color: AppColors.c255_255_255
               ),
             )
           ].column(),
           width: this.width / 3 * 2,
         )),
         SizedBox(height: 60),
         GestureDetector(
             child: Container(
               alignment: Alignment.center,
               height: 50,
               width: this.width / 2,
               decoration: BoxDecoration(
                   color: AppColors.c255_225_0,
                   borderRadius: BorderRadius.circular(25)
               ),
               child: Text(intl.register,
                   style: AppStyles.f17w400c255_255_255),
             ),
             onTap: () async{
               var account = _accountController.text.replaceAll(" ", "");
               if (account.isEmpty) {
                 showToast(intl.pleaseInputAccount);
                 return;
               }
               var password = _secretController.text.replaceAll(" ", "");
               if (password.isEmpty) {
                 showToast(intl.pleaseInputPassword);
                 return;
               }

               var rePassword = _reSecretController.text.replaceAll(" ", "");
               if (password != rePassword) {
                 showToast(intl.doublePasswordIsDiffer);
                 return;
               }

               var value = await model.register(account: account,
                   password: password, rePassword: rePassword);
               if (value) {
                 popViewController();
               }
             }
         ),
         SizedBox(height: 160)
       ]
     )
  );
}