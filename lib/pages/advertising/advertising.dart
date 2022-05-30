/*
 *  Copyright (C), 2015-2021
 *  FileName: advertising
 *  Author: Tonight丶相拥
 *  Date: 2021/10/18
 *  Description: 
 **/

import 'dart:async';
import 'package:extended_image/extended_image.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/abstract_mixin/chat_salon.dart';
import 'package:hjnzb/common/abstract_mixin/trtc_mixin.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/generated/banner_entity.dart';
// import 'package:hjnzb/http/http_channel.dart';
// import 'package:hjnzb/manager/app_manager.dart';
// import 'package:im_flutter_sdk/im_flutter_sdk.dart';
// import 'package:hjnzb/pages/live_room/model/TRTCLiveRoomDef.dart';
import 'advertising_model.dart';
import 'type.dart';
import '../login/user_info_operation.dart';

class AdvertisingPage extends StatefulWidget {
  AdvertisingPage([this.banners = const []]);
  final List<BannerEntity> banners;
  @override
  createState() => _AdvertisingPageState();
}

class _AdvertisingPageState extends AppStateBase<AdvertisingPage> with ChatSalon, TRTCOperation {

  @override
  // TODO: implement model
  AdvertisingModel get model => super.model as AdvertisingModel;
  Completer<InitializePage> _completer = Completer();
  bool _completerHasValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var user = AppManager.getInstance<AppUser>();
    _completer.future.then((value) => _completerHasValue = true);
    _completer.future.timeout(Duration(seconds: model.viewModel.count.value), onTimeout: (){
      return InitializePage.logIn;
    });
    UserInfoOperation().userInfo().then((value) {
      _completer.complete(value);
    });
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    leading: SizedBox(),
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    actions: [
      Obx(()=> Text.rich(TextSpan(
          text: "${model.viewModel.count.value}",
          style: AppStyles.f14w400c0_0_0,
          children: [
            if (_completerHasValue)
              TextSpan(
                text: " | ${intl.skip}",
                style: AppStyles.f14w400c0_0_0,
                // recognizer: TapGestureRecognizer()..onTap = (){
                //
                // }
              )
          ]
        )).container(
          height: 30,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(color: Colors.black12)
          )
        )).gestureDetector(onTap: (){
        if (_completerHasValue) {
          model.timerCancel();
          _onTimerUp();
        }
        }).center
        .padding(padding: EdgeInsets.only(
          right: 8))
    ],
  );

  // @override
  // // TODO: implement bodyColor
  // Color? get bodyColor => Colors.white;

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  AppModel? initializeModel() {
    // TODO: implement initializeModel
    return AdvertisingModel(_onTimerUp)..loadData();
  }

  void _onTimerUp() async{
    var value = await _completer.future;
    Navigator.of(context).pushReplacementNamed(value.rawValue!);
  }
  
  @override
  // TODO: implement body
  Widget get body {
    List<BannerEntity> e = widget.banners.where((element) =>
    element.pic != null && element.pic!.replaceAll(" ", "").isNotEmpty).toList();
    return e.length != 0 ? ExtendedImage.network(e[0].pic!, fit: BoxFit.cover,
      enableLoadState: false,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading
            || state.extendedImageLoadState == LoadState.failed) {
          return Image.asset(AppImages.logInNew,
              fit: BoxFit.cover);
        }
      },
    )
        .sizedBox(height: this.height, width: this.width).center :
      Image.asset(AppImages.logInNew, fit: BoxFit.cover);
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    model.dispose();
  }
}