/*
 *  Copyright (C), 2015-2021
 *  FileName: top_view
 *  Author: Tonight丶相拥
 *  Date: 2021/12/10
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/util_tool/util_tool.dart';
import 'animation_view/animation_view.dart';
import 'game_view/game_view_view.dart';
import '../live_room_chat_model.dart';
import 'grade_image.dart';

class LivingRoomTopView extends StatefulWidget {
  LivingRoomTopView(this.id);
  final String Function() id;
  @override
  createState()=> _LivingRoomTopViewState();
}

class _LivingRoomTopViewState extends State<LivingRoomTopView> with TickerProviderStateMixin {

  late final List<LotteryController> _controllers;

  List<GameModel> get _games => AppManager.getInstance<Game>().games.where((element) => element.showFlag).toList();

  AppInternational get intl =>  AppInternational.of(context);

  double _baseBottom = 150;

  LiveRoomChatViewModel get _chats => Get.find<LiveRoomChatViewModel>();

  late final CommonController _winPrizeController;
  late final CommonController _givingGiftController;
  late final CommonController _enterRoomController;
  late final Animation<double> _colorAnimation;

  ChatModel? get _enterModel => _chats.enterRoomList.length == 0 ? null : _chats.enterRoomList.first;
  ChatModel? get _winPrizeModel => _chats.winP.length == 0 ? null : _chats.winP.first;
  ChatModel? get _sendGiftModel => _chats.sendGift.length == 0 ? null : _chats.sendGift.first;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllers = _games.where((element) => element.showFlag).map((e) {
      AnimationController c = AnimationController(vsync: this, duration: Duration(seconds: 10));
      var a = LotteryController(c, [
        AnimatedGroupModel(Tween(begin: 0, end: 1000), Interval(0, 0.4)),
        AnimatedGroupModel(Tween(begin: 0, end: 1000), Interval(0.6, 1))
      ], e.gameName);
      return a;
    }).toList();
    var enterRoomC = AnimationController(vsync: this, duration: Duration(seconds: 5));
    _enterRoomController = CommonController(
       controller: enterRoomC,
       models: [
         AnimatedGroupModel(Tween(begin: 0, end: 1000), Interval(0, 0.6)),
       ]);
    _colorAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      curve: Interval(0.8, 1),
      parent: enterRoomC
    ));

    var giftC = AnimationController(vsync: this, duration: Duration(seconds: 10));
    _givingGiftController = CommonController(
      controller: giftC,
      models: [
        AnimatedGroupModel(Tween(begin: 0, end: 1000), Interval(0, 0.26)),
        AnimatedGroupModel(Tween(begin: 0, end: 1000), Interval(0.6, 1))
      ]
    );

    var winC = AnimationController(vsync: this, duration: Duration(seconds: 10));
    _winPrizeController = CommonController(
      controller: winC,
      models: [
        AnimatedGroupModel(Tween(begin: 0, end: 1000), Interval(0, 0.26)),
        AnimatedGroupModel(Tween(begin: 0, end: 1000), Interval(0.6, 1))
      ]
    );

    EventBus.instance.addListener(_enterListener, name: enterRoom);
    EventBus.instance.addListener(_winPrizeListener, name: winPrize);
    EventBus.instance.addListener(_sendGiftListener, name: givingGift);
    EventBus.instance.addListener(_onVerifyRoom, name: verifyRoomSuccess);
    // _enterRoomScription = _chats.enterRoom.listen((p0) {
    //   _enterListener();
    // });
    // _givingGiftScription = _chats.sendGift.stream.listen((event) {
    //   _sendGiftListener();
    // });
    // _winPrizeScription = _chats.winP.stream.listen((event) {
    //   _winPrizeListener();
    // });
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   if (_winPrizeModel != null && !_winPrizeController.controller.isAnimating) {
    //     _winPrizeController.controller.forward();
    //   }
    //   if (_enterModel != null && !_enterRoomController.controller.isAnimating) {
    //     _enterRoomController.controller.forward();
    //   }
    //   if (_sendGiftModel != null && !_givingGiftController.controller.isAnimating) {
    //     _givingGiftController.controller.forward();
    //   }
    // });
  }

  void _onVerifyRoom(_){
    _enterRoomController.controller.reset();
    _enterIsAnimation = false;

    _winPrizeController.controller.reset();
    _winPrizeIsAnimation = false;

    _givingGiftController.controller.reset();
    _sendGiftIsAnimation = false;
  }

  bool _enterIsAnimation = false;
  void _enterListener(_){
    if (_enterRoomController.controller.isAnimating || _enterIsAnimation) {
      return;
    }else if (_enterRoomController.controller.isDismissed || _enterRoomController.controller.isCompleted) {
      if (_chats.enterRoomList.isNotEmpty){
        _enterIsAnimation = true;
        _enterRoomController.controller.forward().then((value) {
          if (_chats.enterRoomList.length > 0)
            _chats.enterRoomList.removeAt(0);
          _enterRoomController.controller.reset();
          _enterIsAnimation = false;
          _enterListener(null);
        });
      }
    }
  }

  bool _winPrizeIsAnimation = false;
  void _winPrizeListener(_){
    if (_winPrizeController.controller.isAnimating || _winPrizeIsAnimation) {
      return;
    }else if (_winPrizeController.controller.isDismissed || _winPrizeController.controller.isCompleted) {
      if (_chats.winP.isNotEmpty){
        _winPrizeIsAnimation = true;
        _winPrizeController.controller.forward().then((value) {
          _chats.winP.removeAt(0);
          _winPrizeController.controller.reset();
          _winPrizeIsAnimation = false;
          _winPrizeListener(null);
        });
      }
    }
  }

  bool _sendGiftIsAnimation = false;
  void _sendGiftListener(_){
    if (_givingGiftController.controller.isAnimating || _sendGiftIsAnimation) {
      return;
    }else if (_givingGiftController.controller.isDismissed || _givingGiftController.controller.isCompleted) {
      if (_chats.sendGift.isNotEmpty){
        _sendGiftIsAnimation = true;
        _givingGiftController.controller.forward().then((value) {
          _chats.sendGift.removeAt(0);
          _givingGiftController.controller.reset();
          _sendGiftIsAnimation = false;
          _sendGiftListener(null);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int index = _controllers.indexWhere((element) => element.name == "BaccaratGame");
    return Stack(
      children: [
        for (int i = 0; i < _controllers.length; i ++)
          LivingRoomAnimationView(_controllers[i], (140.0 + 70 * i + (index != -1 && i > index ? 30 : 0)).pt),
        // ..._controllers.map((e) {
        //   int index = _controllers.indexOf(e);
        //   return LivingRoomAnimationView(e, (140.0 + 70 * index).pt);
        // }),
        for (int i = 0; i < _games.length; i ++)
          Positioned(child: Column(
              children: [
                Image.asset(AppImages.imageBase + _games[i].gameName + ".png"),
                Obx((){
                  int m = _games[i].count1.value ~/ 60;
                  int s = _games[i].count1.value % 60;
                  return CustomText("${m.toStringAsFixed1(2)}:${s.toStringAsFixed1(2)}",
                    style: TextStyle(
                        fontSize: 12.pt,
                        fontWeight: w_400,
                        color: Color.fromARGB(255, 228, 31, 39)
                    ),
                  );
                }),
              ]
          ).gestureDetector(onTap: (){
            var height = context.height * 0.5;
            var model = _games[i];
            if (model.type == 1){
              height += 120;
            }
            customShowModalBottomSheet(
                context: context,
                fixedOffsetHeight: height,
                enableDrag: false,
                builder: (_) {
                  if (model.type == 0)
                    return Game1View(_games[i], widget.id());
                  else if (model.type == 1)
                    return Game2View(_games[i] as GameModel1, widget.id());
                  else if (model.type == 2)
                    return Game3View(_games[i] as Game2Model, widget.id());
                  return SizedBox.shrink();
                  // return Game1View(_games[i], widget.id());
                },
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent);
          }), bottom: _baseBottom + 80 * i, right: 16),
        Positioned(
          child: Image.asset(AppImages.carMarket).gestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(AppRoutes.carList);
            }),
          right: 16,
          bottom: _baseBottom - 50,
        ),
        CommonAnimationWidget(_winPrizeController, (140 + 70 * (_controllers.length)).pt,
          childBuilder: (_) {
            return Offstage(
              offstage: _enterModel?.name == null
                  || _enterModel?.ex == null
                  || _enterModel?.content == null,
              child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                        height: 36,
                        padding: EdgeInsets.only(left: 46, right: 16),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 245, 130, 28),
                            borderRadius: BorderRadius.circular(18)
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: "${intl.congratulation}${intl.vip}",
                                        style: TextStyle(
                                            color: Colors.white
                                        )
                                    ),
                                    TextSpan(
                                        text: "${_winPrizeModel?.name}",
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 253, 220, 104)
                                        )
                                    ),
                                    TextSpan(
                                        text: "${_winPrizeModel?.content}",
                                        style: TextStyle(
                                            color: Colors.white
                                        )
                                    ),
                                    TextSpan(
                                        text: "${_winPrizeModel?.ex}",
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 253, 220, 104)
                                        )
                                    )
                                  ],
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: w_400
                                  )
                              ))
                            ]
                        )
                    ),
                    Positioned(
                      child: Image.asset(AppImages.winPrizeNotification),
                    )
                  ]
              ),
            );
          }),
        CommonAnimationWidget(_givingGiftController, (140 + 70 * (_controllers.length) + 50).pt,
          childBuilder: (_) {
           return Offstage(
             offstage: _enterModel?.name == null
                 || _enterModel?.ex == null
                 || _enterModel?.content == null,
             child: Stack(
                 alignment: Alignment.bottomLeft,
                 children: [
                   Container(
                       height: 36,
                       padding: EdgeInsets.only(left: 46, right: 16),
                       decoration: BoxDecoration(
                           color: Color.fromARGB(255, 245, 130, 28),
                           borderRadius: BorderRadius.circular(18)
                       ),
                       child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             RichText(text: TextSpan(
                                 children: [
                                   TextSpan(text: "${intl.vip}",
                                       style: TextStyle(
                                           color: Colors.white
                                       )
                                   ),
                                   TextSpan(
                                       text: "${_sendGiftModel?.name}",
                                       style: TextStyle(
                                           color: Color.fromARGB(255, 253, 220, 104)
                                       )
                                   ),
                                   TextSpan(
                                       text: "${_sendGiftModel?.content}",
                                       style: TextStyle(
                                           color: Colors.white
                                       )
                                   ),
                                   TextSpan(
                                       text: "${_sendGiftModel?.ex}",
                                       style: TextStyle(
                                           color: Color.fromARGB(255, 253, 220, 104)
                                       )
                                   )
                                 ],
                                 style: TextStyle(
                                     fontSize: 14, fontWeight: w_400
                                 )
                             ))
                           ]
                       )
                   ),
                   Positioned(
                     child: Image.asset(AppImages.sendGiftNotification),
                   )
                 ]
             )
           );
          }),
        CommonAnimationWidget(
          _enterRoomController,
          266,
          isBottom: true,
          childBuilder: (_) {
            return Offstage(
              offstage: _enterModel?.name == null
                  || _enterModel?.level == null
                  || _enterModel?.content == null,
              child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 84, 222, 248),
                        Color.fromARGB(255, 235, 121, 239),
                        Color.fromARGB(255, 244, 167, 153),
                        Color.fromARGB(255, 247, 190, 76),
                        Color.fromARGB(255, 246, 183, 101).withOpacity(0.13),
                        Colors.black.withOpacity(0)
                      ]),
                      borderRadius: BorderRadius.circular(17)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      RichText(text: TextSpan(
                          children: [
                            WidgetSpan(child: GradeImageWidget(_enterModel?.level ?? 1)),
                            WidgetSpan(child: SizedBox(width: 4)),
                            TextSpan(text: "${_enterModel?.name}  ", style: TextStyle(
                                fontSize: 12, fontWeight: w_600,
                                color: Colors.white
                            )),
                            TextSpan(
                                text: "${_enterModel?.content}",
                                style: TextStyle(
                                    fontWeight: w_500,
                                    fontSize: 12,
                                    color: Colors.white
                                )
                            )
                          ]
                      ))
                    ],
                  )
              ).opacity(_colorAnimation.value),
            );
          }
        ),
        _CarDisplay().center
        // Positioned(child: Column(
        //     children: [
        //       Image.asset(AppImages.imageBase + _game.game2!.gameName + ".png"),
        //       Obx((){
        //         int m = _game.game2!.count1.value ~/ 60;
        //         int s = _game.game2!.count1.value % 60;
        //         return CustomText("${m.toStringAsFixed1(2)}:${s.toStringAsFixed1(2)}",
        //           style: TextStyle(
        //               fontSize: 12.pt,
        //               fontWeight: w_400,
        //               color: Color.fromARGB(255, 228, 31, 39)
        //           ),
        //         );
        //       }),
        //     ]
        // ).gestureDetector(
        //   onTap: (){
        //     customShowModalBottomSheet(
        //         context: context,
        //         fixedOffsetHeight: context.height * 0.5,
        //         enableDrag: false,
        //         builder: (_) {
        //           return Game1View(_game.game2!, widget.id);
        //         },
        //         backgroundColor: Colors.transparent,
        //         barrierColor: Colors.transparent);
        //   }
        // ), bottom: _baseBottom + 80, right: 16)
      ]
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllers.forEach((element) {
      element.removeListener();
    });
    _enterRoomController.dispose();
    _winPrizeController.dispose();
    _givingGiftController.dispose();
    super.dispose();
    EventBus.instance.removeListener(_enterListener, name: enterRoom);
    EventBus.instance.removeListener(_winPrizeListener, name: winPrize);
    EventBus.instance.removeListener(_sendGiftListener, name: givingGift);
    EventBus.instance.removeListener(_onVerifyRoom, name: verifyRoomSuccess);
    // _winPrizeScription.cancel();
    // _givingGiftScription.cancel();
    // _enterRoomScription.cancel();
  }
}

class _CarDisplay extends StatefulWidget {
  @override
  createState()=> _CarDisplayState();
}

class _CarDisplayState extends State<_CarDisplay> {

  LiveRoomChatViewModel get _chats => Get.find<LiveRoomChatViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EventBus.instance.addListener(_onListen, name: enterRoom);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EventBus.instance.removeListener(_onListen, name: enterRoom);
  }

  void _onListen(_){
    if (_chats.cars.length == 0 || isAnimation) {
      if (_chats.cars.isEmpty)
        setState(() {});
      return;
    }
    isAnimation = true;
    setState(() {});
  }

  bool isAnimation = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool offstage =  _chats.cars.length == 0;
    return Offstage(
      offstage: offstage,
      child: offstage ? SizedBox.shrink() :
      CustomGiftView.network(_chats.cars[0], onFinish: (){
        isAnimation  = false;
        if (_chats.cars.length > 0){
          _chats.cars.removeAt(0);
        }else {
          setState(() {});
        }
        _onListen(null);
      }, loop: false)
    );
  }
}