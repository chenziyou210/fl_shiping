/*
 *  Copyright (C), 2015-2021
 *  FileName: live_room_anchor
 *  Author: Tonight丶相拥
 *  Date: 2021/12/10
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/agora_rtc/agora_rtc.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live_room_preview/beauty_view.dart';
import 'live_room_chat_model.dart';
import 'live_room_new_logic.dart';
import 'view/top_view.dart';
import 'view/cost_alert/cost_alert.dart';
import 'view/room_info_page/room_info_page.dart';

class LiveRoomAnchorPage extends StatefulWidget {
  LiveRoomAnchorPage({dynamic arguments}):
    this.channelName = arguments["channelName"],
    this.channelToken = arguments["channelToken"],
    this.chatRoomId = arguments["chatRoomId"],
    this.channelUid = arguments["channelUid"],
    this.roomId = arguments["roomId"];
  final String roomId;
  final String channelName;
  final String chatRoomId;
  final String channelToken;
  final int channelUid;
  @override
  createState()=> _LiveRoomAnchorPageState();
}

class _LiveRoomAnchorPageState extends AppStateBase<LiveRoomAnchorPage> {

  /// 数据
  final LiveRoomNewLogic _controller = LiveRoomNewLogic();

  /// 直播
  final AgoraRtcLogic _agoraController = AgoraRtcLogic();

  final IMModel imModel = IMModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controller);
    Get.put(_agoraController);
    Get.put(imModel.chats);
    _controller.roomInfo(roomId: widget.roomId);
    _controller.audienceNumber(roomId: widget.roomId);
    _controller.runtimeGame();
    AgoraRtc.rtc.rtcAddListener(_agoraController);
    AgoraRtc.rtc.startLiving(widget.channelName, widget.channelToken, widget.channelUid);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<LiveRoomNewLogic>();
    Get.delete<AgoraRtcLogic>();
    AgoraRtc.rtc.leaveChannel();
    AgoraRtc.rtc.removeRtcListener();
    HttpChannel.channel.destroyRoom(roomId: widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(child: body, onWillPop: () async{
      var value = await alertViewController(CloseLivingAlertWidget(
        coins: "",
        onConfirm: (){
          popViewController(true);
        },
        onCancel: (){
          popViewController(false);
        }
      ));
      return value;
    });
  }

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement body
  Widget get body => Stack(
    children: [
      Container(),
      Positioned.fill(child: LocalView()),
      Positioned.fill(child: RoomInfoPage(true,
          imModel,
          imRoomId: widget.chatRoomId,
          anchorId: ()=> widget.roomId,
      ).paddingOnly(
          top: 35.pt, left: 8, right: 8
      )),
      Positioned.fill(child: FutureBuilder(builder: (_, __) {
        return LivingRoomTopView(()=> widget.roomId);
      }, future: Future.delayed(Duration(milliseconds: 100)))),
      Positioned(child: Column(
          children: [
            _Item(
                image: AppImages.livingSwitchCamera,
                onTap: (){
                  AgoraRtc.rtc.switchCamera();
                }
            ),
            SizedBox(height: 16),
            _Item(
                image: AppImages.livingBeauty,
                onTap: (){
                  customShowModalBottomSheet(context: context,
                      fixedOffsetHeight: this.height * 0.5,
                      isScrollControlled: false,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return BeautyView();
                      });
                }
            ),
            SizedBox(height: 16),
            _Item(
                image: AppImages.livingTime,
                onTap: (){
                  // todo 时段
                  pushViewControllerWithName(AppRoutes.livingTimeSlot);
                }
            ),
          ]
      ), right: 8, top: 260.pt)
    ]
  );
}


class _Item extends StatelessWidget {
  _Item({required this.onTap, required this.image});
  final VoidCallback onTap;
  final String image;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 34.pt,
      height: 34.pt,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(17.pt)
      ),
      child: Image.asset(image), //width: 20.pt, height: 20.pt,
          // fit: BoxFit.fill),
    ).gestureDetector(onTap: onTap);
  }
}