/*
 *  Copyright (C), 2015-2021
 *  FileName: register_new
 *  Author: Tonight丶相拥
 *  Date: 2021/12/6
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:video_player/video_player.dart';
import 'register_new_logic.dart';
import 'image_code_view.dart';

class RegisterNewPage extends StatefulWidget {
  RegisterNewPage({dynamic arguments}): this._controller = arguments["videoPlayer"];
  final VideoPlayerController? _controller;
  @override
  createState() => _RegisterNewPageState();
}

class _RegisterNewPageState extends AppStateBase<RegisterNewPage> with Toast {

  /// 账号
  final TextEditingController _phoneAccount = TextEditingController();
  final TextEditingController _verificationCode = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordNode = FocusNode();
  final TextEditingController _confirmPassword = TextEditingController();
  final FocusNode _confirmPasswordNode = FocusNode();
  final InputBorder _border = UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white
    )
  );

  /// 数据操作
  final RegisterNewLogic _controller = RegisterNewLogic();

  /// 样式
  final TextStyle _style = TextStyle(
    fontSize: 16.pt,
    fontWeight: w_400,
    color: Colors.white
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
    Get.delete<RegisterNewLogic>();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    backgroundColor: Colors.transparent,
    leadingWidth: this.width,
    leading: Row(
      children: [
        SizedBox(width: 24),
        Image.asset(AppImages.contactServise),
        SizedBox(width: 4),
        CustomText("${intl.contactService}",
          fontSize: 14,
          fontWeight: w_500,
          color: Colors.white
        ).cupertinoButton(
            onTap: (){
              pushViewControllerWithName(AppRoutes.contactServicePage, arguments: {
                "url": AppManager.getInstance<GlobalSettingModel>()
                    .viewModel.serviceUrl ?? "",
                "title":"${intl.customService}",

              });
            },
            miniSize: 24
        )
      ]
    )
  );

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement resizeToAvoidBottomInset
  bool? get resizeToAvoidBottomInset => false;

  @override
  // TODO: implement body
  Widget get body => Stack(
    children: [
      Container(),
      if (widget._controller != null)
        Positioned.fill(child: VideoPlayer(widget._controller!))
      else
        Positioned.fill(child: Image.asset(AppImages.logInNew, fit: BoxFit.fill)),
      SafeArea(child: VisibleSingleScrollView(
        children: [
          SizedBox(height: 24.pt),
          Row(
            children: [
              Container(
                width: 70.pt,
                height: 70.pt,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.black12
                ),
                child: Image.asset(AppImages.logInLogo,
                    width: 70.pt, height: 70.pt,
                    fit: BoxFit.fill
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText("oo.live",
                    fontSize: 28.pt,
                    fontWeight: w_600,
                    color: Colors.white
                  ),
                  SizedBox(height: 4),
                  CustomText("${intl.iKnowYourSoulBestAndWillMeetYouSoon}",
                    fontWeight: w_400,
                    fontSize: 16.pt,
                    color: Colors.white
                  )
                ]
              ).expanded()
            ]
          ),
          SizedBox(height: 79.pt),
          CustomTextField(
            controller: _phoneAccount,
            style: _style,
            hintTextStyle: _style,
            textAlignVertical: TextAlignVertical.top,
            prefixIcon: Image.asset(AppImages.phoneAccount),
            hintText: "${intl.pleaseEnterPhoneNumber}",
            border: _border
          ),
          SizedBox(height: 43.pt),
          Row(
            children: [
              CustomTextField(
                controller: _verificationCode,
                style: _style,
                hintTextStyle: _style,
                textAlignVertical: TextAlignVertical.top,
                prefixIcon: Image.asset(AppImages.verificationCode),
                hintText: "${intl.pleaseEnterVerificationCode}",
                border: _border
              ).expanded(),
              SizedBox(width: 86.pt),
              CupertinoButton(
                minSize: 40.pt,
                padding: EdgeInsets.zero,
                onPressed: () async{
                  var text = _phoneAccount.text;
                  if (text.isEmpty) {
                    showToast("${intl.pleaseEnterPhoneNumber}");
                    return ;
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
                },
                child: Container(
                  width: 71.pt,
                  height: 40.pt,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.pt),
                    gradient: LinearGradient(colors: AppColors.buttonGradientColors)
                  ),
                  child: CustomText("${intl.send}",
                    fontSize: 16.pt,
                    fontWeight: w_500,
                    color: Colors.white
                  ),
                )
              )
            ]
          ),
          SizedBox(height: 43.pt),
          Obx((){
            return CustomTextField(
              controller: _password,
              node: _passwordNode,
              textAlignVertical: TextAlignVertical.top,
              prefixIcon: Image.asset(AppImages.securityLock),
              suffixIcon: (_controller.state.isShow.value ?
              Image.asset(AppImages.securityShow)
                  : Image.asset(AppImages.securityHide)).gestureDetector(
                  onTap: (){
                    _controller.toggleSecurityLock();
                  }
              ),
              hintText: "${intl.pleaseEnterPassword}",
              hintTextStyle: _style,
              style: _style,
              obscureText: _controller.state.isShow.value,
              fillColor: Colors.white,
              border: _border
            );
          }).sampleVisibleEnsure(_passwordNode),
          SizedBox(height: 43.pt),
          CustomTextField(
            controller: _confirmPassword,
            node: _confirmPasswordNode,
            hintText: "${intl.pleaseConfirmPassword}",
            style: _style,
            textAlignVertical: TextAlignVertical.top,
            hintTextStyle: _style,
            prefixIcon: Image.asset(AppImages.securityLock),
            obscureText: true,
            border: _border
          ).sampleVisibleEnsure(_confirmPasswordNode),
          SizedBox(height: 69.pt),
          CupertinoButton(
            minSize: 60.pt,
            padding: EdgeInsets.zero,
            onPressed: () async{
              var account = _phoneAccount.text;
              var code = _verificationCode.text;
              var password = _password.text;
              var rePassword = _confirmPassword.text;
              if(account.isEmpty) {
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
              if(rePassword.isEmpty) {
                showToast("${intl.pleaseConfirmPassword}");
                return;
              }
              if (password != rePassword) {
                showToast("${intl.twoPasswordIsNotSame}");
                return;
              }
              /// 注册
              var result = await _controller.register(account: account,
                  password: password, rePassword: rePassword, verifyCode: code);
              if (result) {
                /// 返回账号密码
                popViewController({
                  "account": account,
                  "password": password
                });
              }
            },
            child: Container(
              width: 248.pt,
              height: 60.pt,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.pt),
                gradient: LinearGradient(colors: AppColors.buttonGradientColors)
              ),
              child: CustomText("${intl.register}",
                fontSize: 16.pt,
                fontWeight: w_bold,
                color: Colors.white
              )
            )),
          SizedBox(height: 16)
        ],
        needBounds: false
      ).padding(padding: EdgeInsets.symmetric(horizontal: 24)), left: false,
          right: false, bottom: false)
    ]
  );
}