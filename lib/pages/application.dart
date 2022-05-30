/*
 *  Copyright (C), 2015-2021
 *  FileName: application
 *  Author: Tonight丶相拥
 *  Date: 2021/7/13
 *  Description: 
 **/

import 'dart:async';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/abstract_mixin/chat_salon.dart';
import 'package:hjnzb/common/abstract_mixin/trtc_mixin.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:hjnzb/generated/banner_entity.dart';
import 'package:hjnzb/http/cache.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/i18n/local_model.dart';
import 'package:hjnzb/manager/app_manager.dart';
// import 'package:hjnzb/page_config/page_config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:tencent_trtc_cloud/furender/furender.dart';
// import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import '../manager/app_manager.dart';
import '../manager/app_manager.dart';
import '../page_config/page_generate.dart';
import 'advertising/advertising.dart';
// import 'live_room/model/TRTCLiveRoomDef.dart';
import 'advertising/type.dart';
// import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'login/user_info_operation.dart';
import 'dart:io';
class Application extends StatefulWidget {

  @override
  createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with BaseWidgetImplements,
    ChatSalon, TRTCOperation {

  Completer<InitializePage> _completer = Completer();

  List<BannerEntity> _banners =[];

  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';


  @override
  void initState(){
    super.initState();
    // TRTCCloud.sharedInstance().then((value) {
    //   value!.setLicense(url: url, key: key);
    // });
    _getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('收到推送消息');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('点击推送消息');
    });
    // FuRenderManager.manager.setUp(auth, listener: FuRenderParameterStore());
    // AppManager.getInstance<ChatsListViewModel>().addChatsListener();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent,
    //       statusBarBrightness: Brightness.light);
    //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // });
  }

  _getToken() async {
    String? value = await AppCacheManager.cache.getUserToken();
    var user = AppManager.getInstance<AppUser>();
    user.fromMemory(value);
    String? token = user.token;
    if (token != null && token.isNotEmpty) {
      var result = await HttpChannel.channel.homeBanner(1).then((value) => value.finalize<WrapperModel>(
        wrapper: WrapperModel()
      ));
      List lst = result.object ?? [];
      _banners = lst.map((e) => BannerEntity.fromJson(e)).toList();
      if(_banners.length != 0) {
        _completer.complete(InitializePage.advertising);
        return;
      }
      var type = await UserInfoOperation().userInfo();
      _completer.complete(type);

    }else {
      _deviceDetails();

    }
  }

 _guestLogin(String deviceCode) {
    HttpChannel.channel.guestlogin(deviceCode)
        .then((value) =>
        value.finalize(
            wrapper: WrapperModel(),
            failure: (e) {
            },
            success: (data) async {
              var user = AppManager.getInstance<AppUser>();
              user.setToken(data);
              var result = await HttpChannel.channel.homeBanner(1).then((
                  value) =>
                  value.finalize<WrapperModel>(
                      wrapper: WrapperModel()
                  ));
              List lst = result.object ?? [];
              _banners = lst.map((e) => BannerEntity.fromJson(e)).toList();
              if (_banners.length != 0) {
                _completer.complete(InitializePage.advertising);
                return;
              }
              var type = await UserInfoOperation().userInfo();
              _completer.complete(type);
              AppCacheManager.cache.setisGuest(true);
            }
        ));
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil().initialize();
    return FutureBuilder<InitializePage>(builder: (_, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return Center(
            child: Image.asset(AppImages.hhh, fit: BoxFit.cover)
                .sizedBox(height: double.infinity, width: double.infinity)
        );
      }
      var value = snapshot.data!.rawValue;
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => unFocusWith(context),
          child: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: LocalModel.local),
                ChangeNotifierProvider.value(value: AppManager.getInstance<AppUser>()),
                // ChangeNotifierProvider.value(value: AppManager.getInstance<ChatsListViewModel>()),
                ChangeNotifierProvider.value(value: AppManager.getInstance<GlobalSettingModel>().viewModel)
              ],
              child: Consumer<LocalModel>(builder: (_, localModel, __) {
                return MaterialApp(
                    theme: ThemeData(
                        scaffoldBackgroundColor: AppMainColors.backgroudColor,
                        appBarTheme: AppBarTheme(
                            elevation: 0,
                            centerTitle: true,
                            systemOverlayStyle: SystemUiOverlayStyle.light,
                            color: Colors.transparent
                        )
                    ),
                    supportedLocales: AppInternational.delegate.supportedLocales,
                    localizationsDelegates: [
                      AppInternational.delegate,
                      RefreshLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate
                    ],
                    locale: localModel.locale,
                    debugShowCheckedModeBanner: false,
                    title: "hjnzb",
                    routes: {},
                    onGenerateRoute: PageGenerate.generate,
                    initialRoute: value,
                    home: value == null ? AdvertisingPage(_banners): null,
                    builder: EasyLoading.init()
                );
              })
          )
      );
    }, future: _completer.future);
  }

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model!;
          deviceVersion = build.version.toString();
          identifier = build.androidId!;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name!;
          deviceVersion = data.systemVersion!;
          identifier = data.identifierForVendor!;
        }); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    _guestLogin(identifier.isNotEmpty?identifier:generateRandomString(16));
  }

// Define a reusable function
  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();
    return randomString;
  }

}