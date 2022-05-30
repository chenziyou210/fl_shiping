/*
 *  Copyright (C), 2015-2021
 *  FileName: login_new
 *  Author: Tonight丶相拥
 *  Date: 2021/12/6
 *  Description: 
 **/

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:video_player/video_player.dart';

import '../../http/cache.dart';
import '../../http/http_channel.dart';
import '../../i18n/local_model.dart';
import '../mine/log_out.dart';
import 'login_new_logic.dart';

class LogInNewPage extends StatefulWidget {
  @override
  createState() => _LogInNewPageState();
}

class _LogInNewPageState extends AppStateBase<LogInNewPage> with Toast {
  /// 逻辑
  final LogInLogic _controller = LogInLogic();

  /// 视频播放器
  VideoPlayerController? _videoController;

  /// 视频播放
  late final Future _future;

  /// 视频播放
  late final Future<bool> _future1;

  late bool _isAudit;

  bool get isAudit => true;

  /// 账号
  final TextEditingController _accountEditing = TextEditingController();
  final FocusNode _accountNode = FocusNode();

  /// 密码
  final TextEditingController _securityPasswordEditing =
      TextEditingController();
  final FocusNode _securityPasswordNode = FocusNode();

  /// 样式
  final TextStyle _style =
      TextStyle(fontSize: 16.pt, fontWeight: w_400, color: AppMainColors.whiteColor100);
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  String idToken = "";

  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User? user = (await _auth.signInWithCredential(credential)).user;
      idToken = await user!.getIdToken(true);
      print('-------------------' + idToken.toString() + '-------------------');
    } catch (e) {
      // SnackTool.showSnackText(context, "Auth error !");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Completer<bool> _completer = Completer();
    _future1 = _completer.future;
    var setting = AppManager.getInstance<GlobalSettingModel>();
    var value1 = setting.getPackageVersion();
    setting.getSystemParam()
      ..then((value) async {
        await value1;
        if (setting.viewModel.isSameVersion) {
          _completer.complete(true);
        } else {
          _videoController = VideoPlayerController.asset(AppImages.video)
            ..initialize();
          _videoController!.setLooping(true);
          _future = _videoController!.play();
          _completer.complete(false);
        }
      });

    Get.put<LogInLogic>(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController?.pause();
    _videoController?.dispose();
    Get.delete();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: this.width,
        actions: [
          Image.asset(AppImages.contactServise),
          CustomText("${intl.contactService}",
                  textAlign: TextAlign.start,
                  fontSize: 14,
                  fontWeight: w_500,
                  color: Colors.white)
              .cupertinoButton(
            onTap: () {
              pushViewControllerWithName(AppRoutes.contactServicePage,
                  arguments: {
                    "url": AppManager.getInstance<GlobalSettingModel>()
                            .viewModel
                            .serviceUrl ??
                        "",
                    "title":"${intl.customService}",
                  });
            },
            // miniSize: 24
          ),
          Flexible(
            child: Text(''),
            fit: FlexFit.tight,
          ),
          Container(
            padding:
                EdgeInsets.only(right: 8) + EdgeInsets.symmetric(vertical: 8),
            child: CustomText(intl.switchLanguage,
                fontSize: 14, color: Colors.white),
          ).cupertinoButton(onTap: () {
            var value = LocalModel.localeName(context);
            var values = ["中文", "English"];
            Pickers.showSinglePicker(context,
                data: values,
                selectData: value,
                pickerStyle: PickerStyle(
                    commitButton: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 22, right: 12),
                      child: Text('${intl.confirm1}',
                          style: TextStyle(
                              color: Theme.of(context).unselectedWidgetColor,
                              fontSize: 16.0)),
                    ),
                    cancelButton: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 22, right: 12),
                      child: Text('${intl.cancel}',
                          style: TextStyle(
                              color: Theme.of(context).unselectedWidgetColor,
                              fontSize: 16.0)),
                    )), onConfirm: (_, index) async {
              LocalModel.local.changeLocal(index + 1);
              Future.delayed(Duration(milliseconds: 100), () {
                AppManager.getInstance<GlobalSettingModel>().getSystemParam();
              });
            });
          }).center
        ],
      );

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement resizeToAvoidBottomInset
  bool? get resizeToAvoidBottomInset => false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoadingWidget(
        builder: (_, snapShot) {
          _isAudit = snapShot.data;
          return scaffold;
        },
        future: _future1);
  }



  @override
  // TODO: implement body
  Widget get body => isAudit
      ? Stack(children: [
          Container(),
          Positioned.fill(
              child: Image.asset(AppImages.logInNew, fit: BoxFit.fill)),
          _view
        ])
      : LoadingWidget(
          builder: (_, __) {
            return Stack(children: [
              Container(),
              Positioned.fill(child: VideoPlayer(_videoController!)),
              _view
            ]);
          },
          future: _future);

  Widget get _view => SafeArea(
      child: VisibleSingleScrollView(children: [
        SizedBox(height: 24.pt),
        Row(children: [
          Container(
            width: 70.pt,
            height: 70.pt,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.black12
            ),
            child: Image.asset(AppImages.logInLogo,
                width: 70.pt, height: 70.pt, fit: BoxFit.fill),
          ),
          SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomText("oo.live",
                fontSize: 28.pt, fontWeight: w_600, color: Colors.white),
            SizedBox(height: 4),
            CustomText("${intl.iKnowYourSoulBestAndWillMeetYouSoon}",
                fontWeight: w_400, fontSize: 16.pt, color: Colors.white)
          ]).expanded()
        ]),
        SizedBox(height: 56.pt),
        CustomTextField(
          controller: _accountEditing,
          node: _accountNode,
          hintText: "${intl.pleaseEnter} ${intl.account}",
          hintTextStyle: _style,
          style: _style,
          prefixIcon: Image.asset(AppImages.phoneAccount),
          fillColor: Colors.white,
          textAlignVertical: TextAlignVertical.top,
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ).sampleVisibleEnsure(_accountNode),
        SizedBox(height: 54.pt),
        Obx(() {
          return CustomTextField(
            controller: _securityPasswordEditing,
            node: _securityPasswordNode,
            textAlignVertical: TextAlignVertical.top,
            prefixIcon: Image.asset(AppImages.securityLock),
            suffixIcon: (_controller.state.isShow.value
                    ? Image.asset(AppImages.securityShow)
                    : Image.asset(AppImages.securityHide))
                .gestureDetector(onTap: () {
              _controller.toggleSecurityLock();
            }),
            hintText: "${intl.pleaseEnterPassword}",
            hintTextStyle: _style,
            style: _style,
            obscureText: _controller.state.isShow.value,
            fillColor: Colors.white,
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          );
        }).sampleVisibleEnsure(_securityPasswordNode),
        SizedBox(height: 36.pt),
        CupertinoButton(
            minSize: 60.pt,
            padding: EdgeInsets.zero,
            onPressed: () async {
              var account = _accountEditing.text.replaceAll(" ", "");
              if (account.isEmpty) {
                showToast(intl.pleaseInputAccount);
                return;
              }
              var password = _securityPasswordEditing.text.replaceAll(" ", "");
              if (password.isEmpty) {
                showToast(intl.pleaseInputPassword);
                return;
              }
              _logIn(account, password);
            },
            child: Container(
              width: 248.pt,
              height: 60.pt,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.pt),
                  gradient:
                      LinearGradient(colors: AppColors.buttonGradientColors)),
              child: CustomText("${intl.logIn}",
                  fontSize: 16.pt, fontWeight: w_bold, color: Colors.white),
            )),
        // Spacer(),
        SizedBox(height: 18.pt),
        Row(children: [
          TextButton(
              onPressed: () {
                _videoController?.pause();
                pushViewControllerWithName(AppRoutes.forgetPassword)
                    .then((value) {
                  _videoController?.play();
                  if (value != null && value is Map) {
                    String account = value["account"];
                    String password = value["password"];
                    _accountEditing.text = account;
                    _securityPasswordEditing.text = password;
                    _logIn(account, password);
                  }
                });
              },
              child: CustomText("${intl.forget}?",
                  style: TextStyle(
                      fontWeight: w_500, color: Colors.white, fontSize: 16))),
          Spacer(),
          TextButton(
              onPressed: () {
                pushViewControllerWithName(AppRoutes.registerNew, arguments: {
                  "videoPlayer": isAudit ? null : _videoController
                }).then((value) {
                  if (value != null && value is Map) {
                    String account = value["account"];
                    String password = value["password"];
                    _accountEditing.text = account;
                    _securityPasswordEditing.text = password;
                    _logIn(account, password);
                  }
                });
              },
              child: CustomText("${intl.register}",
                  style: TextStyle(
                      fontWeight: w_500, color: Colors.white, fontSize: 16))),
        ]),
        SizedBox(height: 18.pt),
        Row(children: [
          CustomDivider(color: Color.fromARGB(255, 191, 191, 195)).expanded(),
          CustomText("${intl.signUpWith}",
                  fontSize: 14.pt,
                  fontWeight: w_500,
                  color: Color.fromARGB(255, 191, 191, 195))
              .padding(padding: EdgeInsets.symmetric(horizontal: 12)),
          CustomDivider(color: Color.fromARGB(255, 191, 191, 195)).expanded()
        ]),
        SizedBox(height: 32.pt),
        Row(children: [
          Column(children: [
            Image.asset(AppImages.facebookIcon),
            SizedBox(height: 8),
            CustomText("Facebook",
                fontSize: 12.pt,
                fontWeight: w_500,
                color: Color.fromARGB(255, 191, 191, 195))
          ]).cupertinoButton(onTap: () {}),
          Spacer(),
          Column(children: [
            Image.asset(AppImages.googleIcon),
            SizedBox(height: 8),
            CustomText("Google",
                fontSize: 12.pt,
                fontWeight: w_500,
                color: Color.fromARGB(255, 191, 191, 195))
          ]).cupertinoButton(onTap: () {
            signInWithGoogle();
          }),
          Spacer(),
          Column(children: [
            Image.asset(AppImages.whatsappIcon),
            SizedBox(height: 8),
            CustomText("whatsapp",
                fontSize: 12.pt,
                fontWeight: w_500,
                color: Color.fromARGB(255, 191, 191, 195))
          ]).cupertinoButton(onTap: () {})
        ]),
        // Spacer()
        SizedBox(height: 36.pt)
      ], needBounds: false)
          .padding(padding: EdgeInsets.symmetric(horizontal: 24)),
      left: false,
      right: false,
      bottom: false);

  void _logIn(String account, String password) async {

    bool? isguest=AppCacheManager.cache.getisGuest();
    if(isguest==true){
      HttpChannel.channel.logOut();
      AppManager.getInstance<AppUser>().logOut();
    }

    var value = await _controller.logIn(account, password, "");
    if (value) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.tab, (route) => false);
    }
  }
}
