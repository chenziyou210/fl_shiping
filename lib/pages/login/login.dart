/*
 *  Copyright (C), 2015-2021
 *  FileName: login
 *  Author: Tonight丶相拥
 *  Date: 2021/9/16
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live_room/view/game_view/game_network/GameNetWork.dart';
import 'package:hjnzb/pages/login/login_model.dart';
import 'package:video_player/video_player.dart';

class LogInPage extends StatefulWidget {
  @override
  createState() => LogInPageState<LogInPage>();
}

class LogInPageState<T extends StatefulWidget> extends AppStateBase<T>
    with Toast {
  /// 账号
  final TextEditingController _accountController = TextEditingController();
  final FocusNode _accountNode = FocusNode();

  /// 密码
  final TextEditingController _secretController = TextEditingController();
  final FocusNode _secretNode = FocusNode();

  /// 滚动控制器
  // final ScrollController _scrollController = ScrollController();
  late final VideoPlayerController _videoController;

  @override
  // TODO: implement model
  get model => super.model as LogInModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoController = VideoPlayerController.asset(AppImages.video)
      ..initialize();
    _videoController.setLooping(true);
    _videoController.play();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
      automaticallyImplyLeading: false,
      leading: SizedBox(),
      backgroundColor: Colors.transparent);

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement resizeToAvoidBottomInset
  bool? get resizeToAvoidBottomInset => false;

  @override
  // TODO: implement body
  Widget get body => Stack(children: [
        Container(),
        // Positioned.fill(child: Image.asset(AppImages.logInBackground, fit: BoxFit.fill)),
        // Positioned.fill(
        //   child: AspectRatio(
        //     aspectRatio: this.height / this.width,//_videoController.value.aspectRatio,
        //     child: VideoPlayer(_videoController).container(
        //       constraints: BoxConstraints.expand()
        //     )
        //   )),
        Positioned.fill(
            child: VideoPlayer(_videoController)
                .container(width: this.width, height: this.height)),
        body1
      ]);

  Widget get body1 => SizedBox(
      height: this.height,
      width: this.width,
      child: VisibleSingleScrollView(children: [
        Spacer(),
        SampleVisibleEnsure(_accountNode,
            child: [
              SizedBox(
                child: CustomTextField(
                    style: AppStyles.f14w400c255_255_255,
                    prefixIcon: Image.asset(AppImages.logInAccount),
                    controller: _accountController,
                    node: _accountNode),
                width: this.width / 3 * 2,
              ),
              SizedBox(
                width: this.width / 3 * 2,
                child: CustomDivider(height: 1, color: AppColors.c255_255_255),
              )
            ].column()),
        SizedBox(height: 30),
        SampleVisibleEnsure(_secretNode,
            child: [
              SizedBox(
                child: CustomTextField(
                    obscureText: true,
                    style: AppStyles.f14w400c255_255_255,
                    prefixIcon: Image.asset(AppImages.logInPassword),
                    controller: _secretController,
                    node: _secretNode),
                width: this.width / 3 * 2,
              ),
              SizedBox(
                width: this.width / 3 * 2,
                child: CustomDivider(height: 1, color: AppColors.c255_255_255),
              )
            ].column()),
        SizedBox(height: 60),
        GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: this.width / 2,
              decoration: BoxDecoration(
                  color: AppColors.c255_225_0,
                  borderRadius: BorderRadius.circular(25)),
              child: Text(intl.logIn, style: AppStyles.f17w400c255_255_255),
            ),
            onTap: () async {
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
              var value = await (model as LogInModel).logIn(account, password);
              if (value) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.tab, (route) => false);
              }
            }),
        SizedBox(height: 20),
        SizedBox(
          width: this.width / 2 - 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // GestureDetector(
              //     onTap: (){
              //
              //     },
              //     child: Text(intl.forget, style: AppStyles.f14w400c255_255_255)
              // ),
              SizedBox(),
              GestureDetector(
                  onTap: () {
                    pushViewControllerWithName(AppRoutes.register);
                  },
                  child:
                      Text(intl.register, style: AppStyles.f14w400c255_255_255))
            ],
          ),
        ),
        SizedBox(height: 160)
      ]));

  @override
  AppModel? initializeModel() {
    // TODO: implement initializeModel
    return LogInModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.pause();
    _videoController.dispose();
  }
}
