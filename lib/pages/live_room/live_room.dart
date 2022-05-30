/*
 *  Copyright (C), 2015-2021
 *  FileName: live_room
 *  Author: Tonight丶相拥
 *  Date: 2021/7/28
 *  Description: 
 **/

import 'dart:async';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hjnzb/agora_rtc/agora_rtc.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/live_room_info_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/alert_widget/live_exit_alert.dart';
import 'package:hjnzb/pages/component_widget/level_widget.dart';
import 'package:hjnzb/pages/live/live.dart';
import 'package:hjnzb/pages/live/live_enum.dart';
import 'package:hjnzb/pages/live_room/live_room_enum.dart';
import 'package:hjnzb/pages/live_room/mute_model.dart';
import 'package:provider/provider.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import '../../generated/LiveRoomInfoEntity.dart';
import 'live_room_model.dart';
import 'live_room_chat_model.dart';
import '../alert_widget/live_alert.dart';
import 'view/end_draw/end_draw.dart';

class LiveRoomPage extends StatefulWidget {
  LiveRoomPage({dynamic arguments}): this.channelId = arguments["channelId"] ?? "",
        this.isAnchor = arguments["anchor"] ?? false,
        this.roomName = arguments["roomName"] ?? "",
        this.ownerId = arguments["ownerId"],
        this.uid = arguments["uid"],
        this.token = arguments["token"],
        this.isTimer = arguments["isTimer"] ?? false,
        this.value = arguments["value"],
        this.model = arguments["muteModel"],
        this.chatId = arguments["chatId"],
        this.userId = arguments["userId"];
  @override
  createState() => _LiveRoomPageState();

  final String channelId;
  final bool isAnchor;

  // final String roomId;
  final String ownerId;
  final String? userId;
  final String chatId;
  final String roomName;
  final String token;
  final int uid;
  final bool isTimer;
  final dynamic value;
  final MuteModel? model;
}

class _LiveRoomPageState extends AppStateBase<LiveRoomPage> with Toast, TickerProviderStateMixin {

  @override
  // TODO: implement model
  LiveRoomModel get model => super.model as LiveRoomModel;

  late final IMModel chat;

  /// 滚动
  final ScrollController _scrollController = ScrollController() ;

  Timer? _timer;

  Timer? _liveTimer;

  bool _needLeaveChannel = true;


  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    automaticallyImplyLeading: false,
    leading: SizedBox(),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backwardsCompatibility: true,
    leadingWidth: 10,
    titleSpacing: 0,
    backgroundColor: Colors.transparent,
    title: Row(
        children: [
          SelectorCustom<LiveRoomViewModel, LiveRoomInfoEntity?>(builder: (info) {
            if (info == null) {
              return SizedBox();
            }
            return GestureDetector(
                onTap: () async{
                  if(AppManager.getInstance<AppUser>().userId == widget.ownerId) {
                    return;
                  }
                  var user = await model.userInfo(widget.ownerId, 2);
                  alertViewController(LiveAlertWidget(user, widget.ownerId,
                      isLiveOwner: widget.isAnchor,
                      anchorId: widget.ownerId,
                      userId: "",
                      mute: user.banSpeak ?? false
                  ));
                },
                child: Container(
                  // height: 38,
                    padding: EdgeInsets.only(
                        left: 2, right: 6
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.c0_0_0.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(19)
                    ),
                    child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Container(
                                  width: 34,
                                  height: 34,
                                  color: AppColors.c216_216_216,
                                  child: ExtendedImage.network(info.header ?? "",
                                      enableLoadState: false,
                                      fit: BoxFit.cover)
                              )
                          ),
                          SizedBox(width: 8),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(info.username ?? "", style: AppStyles.f14w500c255_255_255),
                                SizedBox(height: 4),
                                Text("${intl.id}：${info.userId}",//${model.viewModel.id}",
                                    style: AppStyles.f10w400c255_255_255)
                              ]
                          ),
                          SizedBox(width: 20),
                          SelectorCustom<LiveRoomViewModel, bool>(builder: (b) {
                            return GestureDetector(
                                onTap: (){
                                  if (!model.viewModel.follow){
                                    model.follow(widget.ownerId);
                                  }else {
                                    model.followCancel(widget.ownerId);
                                  }
                                },
                                child: (!model.viewModel.follow)
                                    ? Image.asset(AppImages.follow)
                                    : Image.asset(AppImages.followed));
                          }, selector: (l) => l.follow)
                        ]
                    )
                )
            );
          }, selector: (l) => l.roomInfo),
          Spacer(),
          // SelectorCustom<LiveRoomViewModel, LiveRoomInfoEntity?>(builder: (info) {
          //   return GestureDetector(
          //       child: Row(
          //           children: [
          //             _Avatar(_url),
          //             SizedBox(width: 8),
          //             _Avatar(_url),
          //             SizedBox(width: 8),
          //             _Avatar(_url),
          //           ]
          //       ),
          //       onTap: (){
          //         customShowModalBottomSheet(
          //             context: context,
          //             fixedOffsetHeight: this.height * 0.8,
          //             builder: (_) {
          //               return Container(
          //                   width: this.width,
          //                   child: ListPage(
          //                       anchorId: widget.ownerId
          //                   )
          //               );
          //             },
          //             isScrollControlled: false,
          //             barrierColor: Colors.transparent
          //         );
          //       }
          //   ).nullWidget<List>(info?.audiences,
          //       predict: (value) => value.length == 0);
          // }, selector: (l) => l.roomInfo),
          SizedBox(width: 10),
          // Container(
          //   width: 56,
          //   height: 34,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(17),
          //     color: AppColors.c0_0_0.withOpacity(0.25)
          //   ),
          //   alignment: Alignment.center,
          //   child: SelectorCustom<AgoraRtc, int>(
          //     builder: (value) {
          //       return Text("$value", style: AppStyles.f12w500c255_255_255);
          //     },
          //     selector: (l) => l.audience
          //   )
          // ),
          SizedBox(width: 8)
        ]
    ),
    actions: [
      SizedBox()
    ],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.isAnchor) {
      model.dataRefresh();
    }
    /// 游戏运行状况
    model.runtimeGame();
    /// 观众数量
    // AgoraRtc.rtc.audienceNumber(widget.userId!);
    /// 聊天
    chat = IMModel();//, mute: widget.model
    // chat.getRoom(widget.chatId);
    Get.put(chat.chats);
    /// 初始化房间信息
    initRoomInfo().then((value) {
      model.roomInfo(roomId: widget.channelId);
    });
    /// 是否是计时收费
    if (widget.isTimer && !widget.isAnchor) {
      _liveTimer = Timer.periodic(Duration(seconds: 60), (timer) {
        model.timerLive(widget.value, widget.channelId);
      });
    }

    /// 腾讯直播 心跳保持
    if (widget.isAnchor) {
      // _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      //   model.trtcModel.sendHeartBeat();
      // });
    }
  }

  /// 初始化房间消息
  Future<void> initRoomInfo() async {
    if (widget.isAnchor) {
      await AgoraRtc.rtc.startLiving(widget.channelId, widget.token, widget.uid);
    }else {
      await AgoraRtc.rtc.addChannel(widget.channelId, widget.token, widget.uid);
    }
    return ;
  }

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider.value(value: AgoraRtc.rtc),
          ChangeNotifierProvider.value(value: model.viewModel),
          // ChangeNotifierProvider.value(value: chat.viewModel),
        ],
        child: WillPopScope(child: scaffold, onWillPop: () async {
          if (model.viewModel.roomInfo == null)
            return true;
          if (model.viewModel.follow || widget.isAnchor){
            if (widget.isAnchor) {
              HttpChannel.channel.destroyRoom(roomId: widget.userId!);
            }else {
              HttpChannel.channel.audienceExitRoom(roomId: widget.userId!,
                  follow: false);
            }
            return true;
          }
          return alertViewController(LiveExitAlert(
              url: model.viewModel.roomInfo!.header ?? "",
              // roomId: widget.channelId,
              anchorId: widget.ownerId,
              userId: widget.userId!,
              onPop: (){
                popViewController();
              })).then((value) {
            if (value == null) {
              return false;
            }else if (value is bool && !value) {
              HttpChannel.channel.audienceExitRoom(roomId: widget.userId!,
                  follow: false);
            }
            return true;
          });
        })
    );
  }

  @override
  void unFocus() {
    // TODO: implement unFocus
    super.unFocus();
    // chat.viewModel.unFocus();
    // model.trtcModel.viewModel.unFocus();
  }

  @override
  // TODO: implement body
  Widget get body => Stack(
      alignment: Alignment.center,
      children: [
        Container(
            width: this.width,
            height: this.height,
            color: Colors.black
        ),
        if (!widget.isAnchor)
        // SelectorCustom<AgoraRtc, int?>(builder: (remoteUid) {
        //   if (remoteUid == null)
        //     return Image.asset(AppImages.liveRoomPlaceHolder,
        //         width: this.width,
        //         height: this.height,
        //         fit: BoxFit.cover);
        //   return Positioned.fill(child: RemoteView(
        //     uid: remoteUid,
        //     channel: widget.channelId
        //   ));
        // }, selector: (a) => a.remoteUid)
          SizedBox()
        else
          Positioned.fill(child: LocalView()),
        GestureDetector(
          onTap: (){
            unFocus();
          },
          child: Container(
              color: Colors.transparent,
              child: SafeArea(child: Column(
                  children: [
                    // SizedBox(height: 10),
                    SelectorCustom<LiveRoomViewModel, LiveRoomInfoEntity?>(builder: (info) {
                      return Row(
                          children: [
                            SizedBox(width: 10),
                            GestureDetector(
                                onTap: (){

                                },
                                child: Container(
                                    height: 30,
                                    padding: EdgeInsets.only(left: 6, right: 11),
                                    decoration: BoxDecoration(
                                        color: AppColors.c0_0_0.withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Row(
                                        children: [
                                          Image.asset(AppImages.coin),
                                          SizedBox(width: 4),
                                          Text("${info?.coins}", style: AppStyles.f12w500c255_255_255),
                                          SizedBox(width: 11),
                                          Image.asset(AppImages.forwardWhite)
                                        ]
                                    )
                                )
                            ).nullWidget(info),
                            SizedBox(width: 10),
                            // GestureDetector(
                            //     onTap: (){
                            //
                            //     },
                            //     child: Container(
                            //         height: 30,
                            //         padding: EdgeInsets.only(left: 6, right: 11),
                            //         decoration: BoxDecoration(
                            //             color: AppColors.c0_0_0.withOpacity(0.25),
                            //             borderRadius: BorderRadius.circular(15)
                            //         ),
                            //         child: Row(
                            //             children: [
                            //               Text("${intl.guard}：10", style: AppStyles.f12w500c255_255_255),
                            //               SizedBox(width: 10),
                            //               Image.asset(AppImages.forwardWhite)
                            //             ]
                            //         )
                            //     )
                            // ),
                            Spacer(),
                            if (!widget.isAnchor)
                              Builder(builder: (context) {
                                return Hero(tag: "endDrawHero", child: IconButton(
                                    padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                                    alignment: Alignment.centerRight,
                                    onPressed: (){
                                      Scaffold.of(context).openEndDrawer();
                                    },
                                    icon: Image.asset(AppImages.endDrawOpen)));
                                // return GestureDetector(
                                //     onTap: (){
                                //       Scaffold.of(context).openEndDrawer();
                                //     },
                                //     child: Container(
                                //         padding: EdgeInsets.only(
                                //             left: 8, right: 6
                                //         ),
                                //         height: 30,
                                //         decoration: BoxDecoration(
                                //             color: AppColors.c0_0_0.withOpacity(0.25),
                                //             borderRadius: BorderRadius.horizontal(left: Radius.circular(15))
                                //         ),
                                //         child: Row(
                                //             children: [
                                //               RotatedBox(
                                //                   quarterTurns: 2,
                                //                   child: Image.asset(AppImages.forwardWhite)
                                //               ),
                                //               SizedBox(width: 8),
                                //               Text(intl.recommend, style: AppStyles.f12w500c255_255_255)
                                //             ]
                                //         )
                                //     )
                                // );
                              })
                          ]
                      );
                    }, selector: (a) => a.roomInfo),
                    Spacer(),
                    Container(
                        height: 200,
                        width: this.width,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.bottomCenter,
                        child: Obx(() {
                          return ListView.separated(
                              reverse: true,
                              controller: _scrollController,
                              itemBuilder: (_, index) {
                                var model = this.chat.chats.chats[index];
                                if (model.type == TextType.gift){
                                  return Align(
                                      child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: this.width * 0.8
                                          ),
                                          decoration: BoxDecoration(
                                              color: AppColors.c0_0_0.withOpacity(0.25),
                                              borderRadius: BorderRadius.circular(17)
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          child: Text.rich(TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: "${model.name} ",
                                                    style: AppStyles.f15w500c255_199_0,
                                                    recognizer: TapGestureRecognizer()..onTap = () async{
                                                      if (model.id == AppManager.getInstance<AppUser>().userId) {
                                                        return;
                                                      }
                                                      var user = await this.model.userInfo(model.id, 1);
                                                      alertViewController(LiveAlertWidget(user, widget.ownerId,
                                                        isLiveOwner: widget.isAnchor,
                                                        anchorId: widget.ownerId,
                                                        mute: user.banSpeak ?? false, userId: "",));
                                                    }
                                                ),
                                                TextSpan(
                                                    text: intl.giving,
                                                    style: AppStyles.f15w500c0_0_0
                                                ),
                                                TextSpan(
                                                    text: " ${model.content}",
                                                    style: AppStyles.f15w500c255_199_0,
                                                    recognizer: TapGestureRecognizer()..onTap = (){

                                                    }
                                                )
                                              ]
                                          ))
                                      ),
                                      alignment: Alignment.centerLeft
                                  );
                                }

                                return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.c0_0_0.withOpacity(0.25),
                                            borderRadius: BorderRadius.circular(17)
                                        ),
                                        constraints: BoxConstraints(
                                          // maxWidth: this.width * 0.5
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                        child: GestureDetector(
                                            onTap: () async{
                                              if (model.id == AppManager.getInstance<AppUser>().userId) {
                                                return;
                                              }
                                              var user = await this.model.userInfo(model.id, 1);
                                              alertViewController(LiveAlertWidget(user, model.id,
                                                  isLiveOwner: widget.isAnchor,
                                                  anchorId: widget.ownerId,
                                                  mute: user.banSpeak ?? false,
                                                  userId: "",
                                                  onMute: (time) {
                                                    this.chat.sendText("",
                                                        type: TextType.mute, time: time);
                                                  }
                                              ));
                                            },
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  LevelWidget(AppImages.vipBackgroundPurple, model.level!),
                                                  SizedBox(width: 4),
                                                  Text("${model.name} : ", style: AppStyles.f15w500c255_199_0),
                                                  Text("${model.content}", style: AppStyles.f15w500c255_255_255)
                                                ]
                                            )
                                        )
                                    )
                                );
                              },
                              separatorBuilder: (_, __) => SizedBox(height: 5),
                              itemCount: this.chat.chats.chats.length);
                        })
                    ),
                    SizedBox(height: 40),
                    SizedBox(height: 29)
                  ]
              ))
          ),
        ),
        if(widget.isAnchor)
          Positioned(child: OutlinedButton(onPressed: (){
            // this.chat.getRoom(widget.chatId);
            pushViewControllerWithName(AppRoutes.mutingList, arguments: {
              "anchorId": widget.ownerId
            });
          },
              style: ButtonStyle(
                  backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.white)
              ),
              child: CustomText("${intl.mutingList}", fontSize: 14,
                  fontWeight: w_400, color: Colors.black)),
              right: 8)
      ]
  );

  @override
  AppModel? initializeModel() {
    // TODO: implement initializeModel
    return LiveRoomModel(isAnchor: widget.isAnchor, model: widget.model);
  }

  @override
  // TODO: implement resizeToAvoidBottomInset
  bool? get resizeToAvoidBottomInset => false;

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => Colors.black;

  @override
  // TODO: implement endDraw
  Widget? get endDraw => widget.isAnchor ? null
      : LiveRoomEndDraw(widget.userId!, onChange: (model) async{
    var type = LiveEnum.common.getLiveType(model.roomType ?? 0);
    dynamic v;
    if (type == LiveEnum.secret) {
      v = await alertViewController(InputDialog(
          cancel: () {
            popViewController();
          },
          confirm: (text){
            popViewController(text);
          }
      ));
      if (v == null || (v as String).isEmpty) {
        return;
      }
    }else if (type == LiveEnum.ticker){
      v = model.ticketAmount;
    }else if (type == LiveEnum.timer){
      v = model.timeDeduction;
    }else {
      v = "";
    }
  });

  @override
  void dispose() async{
    super.dispose();
    model.dispose();
    if (_needLeaveChannel)
      AgoraRtc.rtc.leaveChannel();
    _timer?.cancel();
    _liveTimer?.cancel();
    Get.delete<LiveRoomChatViewModel>();
    chat.dispose();
  }
}