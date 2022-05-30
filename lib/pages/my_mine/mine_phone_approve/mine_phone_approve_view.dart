import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:hjnzb/config/app_layout.dart';
import '../../../app_images/app_images.dart';
import '../../../common/common_widget/custom_gradientbutton/custom_gradientbutton.dart';
import '../../register/image_code_view.dart';
import 'mine_phone_approve_logic.dart';

class MinePhoneApprovePage extends StatelessWidget {
  final logic = Get.put(MinePhoneApproveLogic());
  final state = Get.find<MinePhoneApproveLogic>().state;

  @override
  Widget build(BuildContext context) {
    state.context = context;
    logic.update();
    return Scaffold(
      appBar: DefaultAppBar(
        title: Text('手机认证', style: TextStyle(color: AppMainColors.whiteColor100, fontSize: 18)),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(space16, space12, space16, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildCountry(),
                  buildLine(),
                  buildPhoneNumber(),
                  buildLine(),
                  buildVerificationCode(),
                  buildLine(),
                  SizedBox(height: space48),
                  Container(
                      width: double.infinity,
                      height: 40,
                      padding: EdgeInsets.fromLTRB(space16, 0, space16, 0),
                      child: GradientButton(
                        //allowTap: false,
                        child: Text('认证'),
                        onPressed: () {
                          logic.approveEvent();
                        },
                      )
                  )
                ]
            ),
          ),
          buildBottom()
        ]
      ),
    );
  }

  Widget buildCountry() {
    return Container(
      height: 55,
      child: Row(
          children: [
            Text('国家与地区', style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100)),
            Text('（+86）中国', textAlign: TextAlign.right, style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100, )).expanded(),
            SizedBox(width: space8),
            Image.asset(AppImages.com_arrow_right, width: 16, height: 16)
          ]
      ),
    );
  }

  Widget buildLine() {
    return Container(
      height: 1.pt,
      color: AppMainColors.separaLineColor4,
    );
  }

  Widget buildPhoneNumber() {
    return Container(
      height: 55,
      child: Row(
        children: [
          Text('手机号码', style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100)),
          CustomTextField(
            controller: state.phoneTEC,
            textAlign: TextAlign.start,
            hintText: '请输入手机号码',
            hintTextStyle: TextStyle(fontSize: 16, color: AppMainColors.whiteColor20),
            style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100),
          ).expanded()
        ],
      )
    );
  }

  Widget buildVerificationCode() {
    return Container(
        height: 55,
        child: Row(
          children: [
            Text('验证码', style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100)),
            CustomTextField(
              controller: state.codeTEC,
              textAlign: TextAlign.start,
              hintText: '请输入验证码',
              hintTextStyle: TextStyle(fontSize: 16, color: AppMainColors.whiteColor20),
              style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100),
            ).expanded(),
            Container(
              height: 32,
              width: 72,
              child: Obx(() {
                return GradientButton(
                  padding: EdgeInsets.all(0),
                  allowTap: state.codeStatus.value,
                  borderRadius: BorderRadius.circular(4),
                  child: Obx(() => Text(state.codeText.value, style: TextStyle(fontSize: 14, color: AppMainColors.whiteColor100))),
                  onPressed: () {
                    logic.codeEvent();
                    // showDialog(context: context, builder: (_) {
                    //   var intl;
                    //   return VerificationCodeAlter(
                    //       imageVerification: intl.imageVerification,
                    //       confirm: intl.confirm,
                    //       refresh: intl.refresh,
                    //       hintText: "${intl.pleaseEnterVerificationCode}",
                    //       onConfirm: (value){
                    //         //popViewController();
                    //         //_controller.sendCode(account: text, verifyCode: value);
                    //       },
                    //       onUuidChange: (uid) {
                    //         //_controller.setUid(uid);
                    //       }
                    //   );
                    // });
                  },
                );
              }),
            )
          ],
        )
    );
  }

  Widget buildBottomItem(String text, String imageText) {
    return Container(
      child: Column(
        children: [
          Image.asset(imageText, width: 36, height: 36),
          Text(text, style: TextStyle(fontSize: 12, color: AppMainColors.whiteColor40))
        ]
      )
    );
  }

  Widget buildBottom() {
    return Positioned(
        bottom: 74,
        left: 0,
        right: 0,
        child: Container(
            child: Column(
              children: [
                Text('实名认证手机号码将用于以下功能', style: TextStyle(fontSize: 14, color: AppMainColors.whiteColor70)),
                SizedBox(height: space16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildBottomItem('手机登入', AppImages.mine_phone_bottom0),
                      buildBottomItem('安全认证', AppImages.mine_phone_bottom1),
                      buildBottomItem('收益', AppImages.mine_phone_bottom2),
                    ]
                )
              ],
            )
        )
    );
  }

}

