import 'dart:io';
import 'package:appscheme/appscheme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hjnzb/http/containers.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/pages/application.dart';
import 'package:httpplugin/httpplugin.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/config.dart';
import 'firebase_message/firebase_config.dart';
import 'http/cache.dart';
import 'http/error_deal.dart';
import 'http/http_channel.dart';
import 'package:get_storage/get_storage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isIOS || Platform.isAndroid) {
  //   var httpProxy = await HttpProxy.createHttpProxy();
  //   HttpOverrides.global = httpProxy;
  // }
  await GetStorage.init();
  var options = EMOptions(
    appKey: appKey,
    deleteMessagesAsExitGroup: true,
    deleteMessagesAsExitChatRoom: true,
    autoAcceptGroupInvitation: true,
    debugModel: true,
  );
  // EMOptions options = EMOptions(appKey: appKey, autoLogin: false, debugModel: true);
  var model = AppManager.getInstance<GlobalSettingModel>();
  await EMClient.getInstance.init(options);
  await HttpChannel.channel.setUpChannel(
      config: HttpConfig(
        ip: model.viewModel.ip,
        port: model.viewModel.port,
        maxSlave: 8,
        maxLongRunningSlave: 5,
        statusCodeIgnoreRetry: [
          401, 403
        ],
        errorDeal: CustomErrorDeal(),
        slaveCloseTime: 600,
        enableOauth: false,
        enableRedirect: false
      ),
      cache: AppCacheManager.cache
  );

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD-pqGSyaDCHLHye3y9-s0TLb6YxAjKQH0',
      appId: '1:746159017307:ios:19c770572841526b381e7e',
      messagingSenderId: '746159017307',
      projectId: 'zbbb-3c4a8',
    ),
  );

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  HttpChannel.channel.addTickContainers(AppRequest.request);

  var appScheme = AppSchemeImpl.getInstance();

  appScheme?.getInitScheme().then((value) {
    if (value != null) {
      print("the scheme value is $value ---- ");
    }
  });

  appScheme?.getLatestScheme().then((value) {
    if (value != null) {
      print("the getLatestScheme value is $value ---- ");
    }
  });

  appScheme?.registerSchemeListener().listen((value) {
    if(value != null){
      print("the registerSchemeListener value is ${value.dataString} --- ");
    }
  });

  try {
    SystemUiOverlayStyle systemUiOverlayStyle;
    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }else {
      // systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light);
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]).then((value) {
      runApp(Application());
    });
  }
  catch(_) {
    runApp(Application());
  }
}