/*
 *  Copyright (C), 2015-2021
 *  FileName: setting
 *  Author: Tonight丶相拥
 *  Date: 2021/7/19
 *  Description: 
 **/

import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/abstract_mixin/chat_salon.dart';
import 'package:hjnzb/common/abstract_mixin/trtc_mixin.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/i18n/local_model.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class SettingPage extends StatefulWidget {
  @override
  createState() => _SettingPageState();
}

const double _rowHeight = 50;
class _SettingPageState extends AppStateBase<SettingPage> with ChatSalon, TRTCOperation {
  final _device = DeviceInfoPlugin();
  Completer<String> _completer = Completer();
  final TextStyle _style = TextStyle(
      fontWeight: w_400,
      fontSize: 14,
      color: Colors.black
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isIOS) {
      _device.iosInfo.then((value) {
        _completer.complete("${value.model} ${value.systemName}${value.systemVersion}");
      });
    }else {
      _device.androidInfo.then((value) {
        _completer.complete("${value.board} ${value.brand} ${value.version.sdkInt}");
      });
    }
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.setting,
        style: AppStyles.f17w400c0_0_0)
  );


  @override
  // TODO: implement body
  Widget get body => Column(
    children: [
      SizedBox(height: 10),
      Container(
        color: AppColors.c255_255_255,
        padding: EdgeInsets.symmetric(
          horizontal: 16
        ),
        child: Column(
          children: [
            // SizedBox(
            //   height: _rowHeight,
            //   child: Row(
            //     children: [
            //       Text(intl.accountSecurity,
            //           style: AppStyles.f14w400c0_0_0),
            //       ExpandInkWellRow(children: [
            //         Image.asset(AppImages.accountProtected),
            //         SizedBox(width: 4),
            //         Text(intl.protected, style: AppStyles.f14w400c105_199_49),
            //         SizedBox(width: 16),
            //         Image.asset(AppImages.forwardGray)
            //       ], onTap: (){
            //         pushViewControllerWithName(AppRoutes.accountSecurity);
            //       })
            //     ]
            //   )
            // ),
            // CustomDivider(
            //   height: 1,
            //   color: AppColors.c239_239_239
            // ),
            SizedBox(
              height: _rowHeight,
              child: Row(
                  children: [
                    Text(intl.blacklist,
                        style: AppStyles.f14w400c0_0_0),
                    ExpandInkWellRow(children: [
                      Image.asset(AppImages.forwardGray)
                    ], onTap: (){
                      pushViewControllerWithName(AppRoutes.blackList);
                    })
                  ]
                )
            ),
            // CustomDivider(
            //   height: 1,
            //   color: AppColors.c239_239_239
            // ),
            // SizedBox(
            //   height: _rowHeight,
            //   child: Row(
            //       children: [
            //         Text(intl.appLock,
            //             style: AppStyles.f14w400c0_0_0),
            //         ExpandInkWellRow(children: [
            //           SelectorCustom<SettingViewModel, int>(
            //             builder: (lock) {
            //               return CupertinoSwitchWidget(
            //                 value: lock == 1,
            //                 onChanged: (value){
            //                   int state = value ? 1 : 0;
            //                   AppManager.getInstance<GlobalSettingModel>().updateAppLock(state);
            //                 },
            //                 activeColor: AppColors.c165_59_227,
            //                 trackColor: AppColors.c232_232_232,
            //               );
            //             },
            //             selector: (s) => s.appLock)
            //         ])
            //       ]
            //   )
            // ),
            CustomDivider(
              height: 1,
              color: AppColors.c239_239_239
            ),
            SizedBox(
              height: _rowHeight,
              child: Row(
                children: [
                  Text(intl.language,
                      style: AppStyles.f14w400c0_0_0),
                  ExpandInkWellRow(children: [
                    SelectorCustom<LocalModel, int>(builder: (index) {
                      var value = LocalModel.localeName(context);
                      return Text("$value", style: AppStyles.f14w400c125_125_125);
                    }, selector: (l) => l.localeIndex),
                    SizedBox(width: 16),
                    Image.asset(AppImages.forwardGray)
                  ], onTap: (){
                    var value = LocalModel.localeName(context);
                    var values = ["中文", "English"];
                    Pickers.showSinglePicker(context, data: values, selectData: value,
                       onConfirm: (_, index) {
                       LocalModel.local.changeLocal(index + 1);
                      // AppManager.getInstance<GlobalSettingModel>().updateLanguage(values[index], index);
                    });
                  })
                ]
              )
            )
          ]
        )
      ),
      // SizedBox(height: 10),
      // Container(
      //   padding: EdgeInsets.symmetric(
      //     horizontal: 16
      //   ),
      //   color: AppColors.c255_255_255,
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: _rowHeight,
      //         child: Row(
      //           children: [
      //             Text(intl.paymentPassword,
      //                 style: AppStyles.f14w400c0_0_0),
      //             ExpandInkWellRow(children: [
      //               Image.asset(AppImages.forwardGray)
      //             ])
      //           ]
      //         )
      //       ),
      //       CustomDivider(
      //         height: 1,
      //         color: AppColors.c239_239_239
      //       ),
      //       SizedBox(
      //         height: _rowHeight,
      //         child: Row(
      //           children: [
      //             Text(intl.stealthPrivilege,
      //                 style: AppStyles.f14w400c0_0_0),
      //             ExpandInkWellRow(children: [
      //               Image.asset(AppImages.forwardGray)
      //             ])
      //           ]
      //         )
      //       ),
      //       CustomDivider(
      //         height: 1,
      //         color: AppColors.c239_239_239
      //       ),
      //       SizedBox(
      //         height: _rowHeight,
      //         child: Row(
      //           children: [
      //             Text(intl.checkForUpdates,
      //                 style: AppStyles.f14w400c0_0_0),
      //             ExpandInkWellRow(children: [
      //               Text("20210701", style: AppStyles.f14w400c125_125_125),
      //               SizedBox(width: 16),
      //               Image.asset(AppImages.forwardGray)
      //             ])
      //           ]
      //         )
      //       )
      //     ]
      //   )
      // ),

      FutureBuilder<String>(builder: (_, snapShot) {
        if (snapShot.connectionState != ConnectionState.done) {
          return SizedBox();
        }
        return Column(
            children: [
              SizedBox(height: 8),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.white,
                  child: Column(
                      children: [
                        InkWellRow(children: [
                          CustomText("${intl.modifyLoginPassword}",
                              style: _style),
                          Spacer(),
                          Image.asset(AppImages.forward)
                        ], onTap: (){
                          pushViewControllerWithName(AppRoutes.changeLogInPassword);
                        }).sizedBox(height: 50),
                        CustomDivider(),
                        // InkWellRow(children: [
                        //   CustomText("${intl.changePaymentPassword}",
                        //       style: _style),
                        //   Spacer(),
                        //   Image.asset(AppImages.forward)
                        // ], onTap: (){
                        //
                        // }).sizedBox(height: 50),
                        // CustomDivider(),
                        Row(children: [
                          CustomText("${intl.logInToTheDevice}",
                              style: _style),
                          Spacer(),
                          CustomText("${snapShot.data}",
                              fontWeight: w_400,
                              fontSize: 11,
                              color: Color.fromARGB(255, 153, 153, 153)
                          )
                        ]).sizedBox(height: 50)
                      ]
                  )
              )
            ]
        );
      }, future: _completer.future),
      SizedBox(height: 10),
      InkWell(
        onTap: (){
          _alert(intl.isSwitchAccount);
        },
        child: Container(
          alignment: Alignment.center,
          color: AppColors.c255_255_255,
          width: double.infinity,
          height: _rowHeight,
          child: Text(intl.switchAccount,
              style: AppStyles.f14w400c0_0_0)
        )
      ),
      SizedBox(height: 10),
      InkWell(
        onTap: (){
          _alert(intl.isLogOut);
        },
        child: Container(
            alignment: Alignment.center,
            color: AppColors.c255_255_255,
            width: double.infinity,
            height: _rowHeight,
            child: Text(intl.dropOut,
                style: AppStyles.f14w400c0_0_0)
        )
      )
    ]
  );

  void _alert(String content){
    alertViewController(AlertDialog(
      content: Text(content),
      title: Text(intl.notice, style: AppStyles.f14w400c0_0_0),
      actions: [
        GestureDetector(
          onTap: (){
            popViewController();
          },
          child: Text(intl.cancel),
        ),
        GestureDetector(
          onTap: () async{
            popViewController();
            AppManager.getInstance<AppUser>().logOut();
            try {
              // true: 是否解除deviceToken绑定。
              await EMClient.getInstance.logout(true);
            } on EMError catch (e) {
              // print('操作失败，原因是: $e');
            }

            // await trtcLogOut();
            // await trtcVoiceRoomLogOut();
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.logInNew, (route) => false);
          },
          child: Text(intl.confirm),
        ),
      ],
    ));
  }

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c243_243_243;
}