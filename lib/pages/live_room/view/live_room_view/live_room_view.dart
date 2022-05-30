/*
 *  Copyright (C), 2015-2022
 *  FileName: live_room_view
 *  Author: Tonight丶相拥
 *  Date: 2022/1/7
 *  Description: 
 **/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hjnzb/agora_rtc/agora_rtc.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hjnzb/page_config/page_config.dart';
import '../../live_room_new_logic.dart';

class LiveRoomView extends StatefulWidget {
  LiveRoomView({required this.isOnlyOne, required this.index});
  final bool isOnlyOne;
  final int index;
  @override
  createState() => _LiveRoomViewState();
}

class _LiveRoomViewState extends State<LiveRoomView> with AutomaticKeepAliveClientMixin {


  /// 数据
  LiveRoomNewLogic get _controller => Get.find<LiveRoomNewLogic>();

  ///
  AgoraRtcLogic get _agoraController => Get.find<AgoraRtcLogic>();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return Obx(() {
      int roomIndex = _controller.state.roomIndex.value;
      if ((widget.isOnlyOne && roomIndex == widget.index) ||
          (!widget.isOnlyOne && widget.index == roomIndex + 1)) {
        return Obx(() {
          if (_agoraController.state.hasRemoteUid.value) {
            return RemoteView(
                uid: _agoraController.state.remoteUid!,
                channel: _controller.state.channelName);
          }
          return Obx((){
            Widget child = BarPulseLoading(
                color: Color.fromARGB(255, 235, 121, 239)
            );
            if (_controller.state.livingState.value != LivingRoomState.linking){
              child = Positioned.fill(child: _LivingError(_controller.state.livingState.value));
            }
            return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                      child: ExtendedImage.network(_controller
                          .state.rooms[_controller.state.roomIndex.value]
                          .roomCover ?? "",
                          enableLoadState: false,
                          fit: BoxFit.cover, loadStateChanged: (state) {
                            if (state.extendedImageLoadState == LoadState.loading
                                || state.extendedImageLoadState == LoadState.failed) {
                              return Image.asset(AppImages.imgPlaceHolder,
                                  fit: BoxFit.cover);
                            }
                          })),
                  child
                ]
            );
          });
        });
      }
      return SizedBox();
    });
  }
}

class _LivingError extends StatefulWidget {
  _LivingError(this.state);
  final LivingRoomState state;
  @override
  createState()=> _LivingErrorState();
}

class _LivingErrorState extends AppStateBase<_LivingError> {

  late Timer _timer;
  RxInt _count = 10.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_count.value <= 0) {
        _timer.cancel();
        popUntil(AppRoutes.tab);
        return;
      }
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return body;
  }

  @override
  // TODO: implement body
  Widget get body => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.livingRoomError),
        SizedBox(height: 16.pt),
        CustomText("${widget.state == LivingRoomState.liverOffline
            ? "${intl.anchorOffline}" : "${intl.enterRoomFailurePleaseCheckBalanceOrNetworkOrCircuit}"}",
            fontSize: 14.pt,
            fontWeight: w_400,
            color: Colors.white
        ).paddingSymmetric(horizontal: 16),
        SizedBox(height: 49.pt),
        Container(
            width: 205.pt,
            height: 60.pt,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 228, 31, 39),
                borderRadius: BorderRadius.circular(30.pt)
            ),
            alignment: Alignment.center,
            child: Obx((){
              return CustomText("（${_count.value}${intl.seconds}）${intl.autoGetBackHomePage}",
                  fontSize: 16.pt,
                  fontWeight: w_500,
                  color: Colors.white
              );
            })
        ).cupertinoButton(
            onTap: (){
              _timer.cancel();
              popViewController();
              // popUntil(AppRoutes.tab);
            }
        )
      ]
  ).container(
      color: Colors.black.withOpacity(0.7)
  );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
}
