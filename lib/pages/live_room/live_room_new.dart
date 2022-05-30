/*
 *  Copyright (C), 2015-2021
 *  FileName: live_room_new
 *  Author: Tonight丶相拥
 *  Date: 2021/12/9
 *  Description: 
 **/

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/agora_rtc/agora_rtc.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/anchor_list_model_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/alert_widget/live_exit_alert.dart';
import 'package:hjnzb/pages/live_room/live_room_chat_model.dart';
import 'package:hjnzb/pages/live_room/view/end_draw/end_draw_new.dart';
import 'package:hjnzb/pages/live_room_preview/live_room_type.dart';
import '../alert_widget/live_exit.dart';
import 'view/cost_alert/cost_alert.dart';
import 'live_room_new_logic.dart';
import 'view/room_info_page/room_info_page.dart';
import 'view/top_view.dart';
import 'view/live_room_view/live_room_view.dart';

class AudienceNewPage extends StatefulWidget {
  AudienceNewPage({dynamic arguments})
      : this.roomIndex = arguments["index"],
        this.rooms = arguments["rooms"];
  final int roomIndex;
  final List<AnchorListModelEntity> rooms;

  @override
  createState() => _AudienceNewPageState();
}

class _AudienceNewPageState extends AppStateBase<AudienceNewPage> {
  /// 数据
  final LiveRoomNewLogic _controller = LiveRoomNewLogic();

  ///
  final AgoraRtcLogic _agoraController = AgoraRtcLogic();

  final IMModel imModel = IMModel();

  late PageController _pageController;
  final PageController _pageController1 = PageController(initialPage: 1);

  String? get _anchorId =>
      _controller.state.rooms[_controller.state.roomIndex.value].id;

  Drag? _drag;

  @override
  void initState() {
    super.initState();
    Get.put(_controller);
    Get.put(_agoraController);
    Get.put(imModel.chats);

    /// 切换直播间
    _controller.changeRoom(index: widget.roomIndex, anchorListData: widget.rooms);
    _pageController = PageController(
      initialPage: widget.rooms.length == 1 ? widget.roomIndex : widget.roomIndex + 1,
      // loop: true,
      // itemCount: widget.rooms.length
    );
    EventBus.instance.addListener(_freeTimeOut, name: freeTimeOut);
    AgoraRtc.rtc.rtcAddListener(_agoraController);

    /// 礼物
    _controller.getGiftData();
    _controller.runtimeGame();
  }

  void _freeTimeOut(model) {
    if (model is AnchorListModelEntity) {
      var length = _controller.state.rooms.length;
      bool isOnlyOne = length == 1;
      var count = isOnlyOne ? 1 : _controller.state.rooms.length + 2;
      int virtualIndex = _controller.state.roomIndex.value + 1;
      var result = _calculate(index: virtualIndex, count: count);

      if (LiveRoomType.ticket.rawValue == model.roomType) {
        _alertTicket(
            jumpIndex: result.jumpIndex,
            count: count,
            index: result.index,
            model: model);
      } else if (LiveRoomType.timer.rawValue == model.roomType) {
        _alertTimer(
            jumpIndex: result.jumpIndex,
            count: count,
            index: result.index,
            model: model);
      }
    }
  }

  // @override
  // PreferredSizeWidget? get appBar => DefaultAppBar(
  //   backgroundColor: Colors.transparent,
  //   leading: SizedBox(),
  //   automaticallyImplyLeading: false,
  //   actions: [
  //     SizedBox()
  //   ],
  // );

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => Colors.black.withOpacity(0.5);

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  bool? get resizeToAvoidBottomInset => false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        child: scaffold,
        onWillPop: () async {
          if (_controller.state.roomInfo == null) return true;
          if (_controller.state.isFollowing.value) {
            HttpChannel.channel
                .audienceExitRoom(roomId: _anchorId!, follow: false);
            return true;
          }
          return

              // alertViewController(LiveExitAlert(
              //   url: _controller.state.roomInfo!.header ?? "",
              //   anchorId: _anchorId!,
              //   userId: _anchorId!,
              //   onPop: () {
              //     popViewController();
              //   }))
              _showExitDialog().then((value) {
            if (value == null) {
              return false;
            } else if (value is bool && !value) {
              HttpChannel.channel
                  .audienceExitRoom(roomId: _anchorId!, follow: false);
            }
            // this.dispose();
            return true;
          });
        });
  }

  Future _showExitDialog() {
    return customShowModalBottomSheet(
        context: context,
        builder: (_) {
          return LiveExit(
              url: _controller.state.roomInfo!.header ?? "",
              anchorId: _anchorId!,
              userId: _anchorId!,
              onPop: () {
                popViewController();
              });
        },
        fixedOffsetHeight: 180.pt,
        isScrollControlled: false,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent);
  }

  bool _isForward = false;

  @override
  Widget get body => GestureDetector(
      onHorizontalDragStart: (details) {
        unFocus();
        _drag = _pageController1.position.drag(details, _dragDispose);
      },
      onHorizontalDragCancel: () {
        _dragDispose();
      },
      onHorizontalDragUpdate: (details) {
        _drag?.update(details);
      },
      onHorizontalDragEnd: (details) {
        _drag?.end(details);
      },
      onVerticalDragStart: (details) {
        unFocus();
        _drag = _pageController.position.drag(details, _dragDispose);
      },
      onVerticalDragCancel: () {
        _dragDispose();
      },
      onVerticalDragUpdate: (details) {
        _isForward = details.delta.dy < 0;
        _drag?.update(details);
      },
      onVerticalDragEnd: (details) {
        _drag?.end(details);
      },
      child: Container(
          color: Colors.transparent,
          child: Stack(children: [
            Obx(() {
              var length = _controller.state.rooms.length;
              bool isOnlyOne = length == 1;

              var count = isOnlyOne ? 1 : _controller.state.rooms.length + 2;
              return PageView.builder(
                  controller: _pageController,
                  pageSnapping: true,
                  itemCount: count,
                  itemBuilder: (_, int index) {
                    if (!isOnlyOne &&
                        (index == 0 ||
                            index == _controller.state.rooms.length + 1)) {
                      return SizedBox.shrink();
                    }
                    return LiveRoomView(isOnlyOne: isOnlyOne, index: index);
                  },
                  onPageChanged: (int index) async {
                    var result = _calculate(index: index, count: count);

                    var jumpIndex = result.jumpIndex;
                    if (result.needChangePage) {
                      await Future.delayed(Duration(milliseconds: 400));
                      _pageController.jumpToPage(jumpIndex);
                    }
                    _controller.changeRoom(index: result.index);
                    // var model = _controller.state.rooms[index];
                    // bool hasFreeTime = model.ticketTryseeTime != null
                    //   && model.ticketTryseeTime! > 0;
                    // if (LiveRoomType.timer.rawValue == model.defaultroom && !hasFreeTime) {
                    //   _alertTimer(jumpIndex: jumpIndex, index: index,
                    //       count: count, model: model);
                    // }else if (LiveRoomType.ticket.rawValue == model.defaultroom && !hasFreeTime){
                    //   _alertTicket(jumpIndex: jumpIndex, index: index,
                    //       count: count, model: model);
                    // }else {
                    //   _controller.changeRoom(index: index);
                    // }
                  },
                  scrollDirection: Axis.vertical);
            }).ignorePointer,
            PageView.builder(
                controller: _pageController1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return SizedBox();
                  }
                  return RoomInfoPage(false, imModel,
                          anchorId: () => _anchorId!)
                      .paddingOnly(top: 35.pt, left: 0, right: 8);
                },
                itemCount: 2),
            Positioned.fill(
                child: FutureBuilder(
                    builder: (_, __) {
                      return LivingRoomTopView(() => _anchorId!);
                    },
                    future: Future.delayed(Duration(milliseconds: 100)))),
            Positioned(
                child: Builder(builder: (context) {
                  return Hero(
                      tag: "endDrawHero",
                      child: IconButton(
                          padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: Image.asset(AppImages.endDrawOpen)));
                }),
                right: 0,
                top: 80.pt)
          ])));

  void _detailEvent(
      {required int jumpIndex, required int count, required int index}) async {
    popUntil(AppRoutes.audiencePage);
    if (_isForward) {
      if (jumpIndex == count - 2) {
        // 下一个页面为第一个页面
        jumpIndex = 1;
        index = 0;
      } else {
        // 下一个页面
        jumpIndex += 1;
        index = jumpIndex - 1;
      }
    } else {
      if (jumpIndex == 1) {
        // 上一个页面为最后一个页面
        jumpIndex = count - 2;
        index = jumpIndex - 1;
      } else {
        // 上一个页面
        jumpIndex -= 1;
        index = jumpIndex - 1;
      }
    }
    _pageController.jumpToPage(jumpIndex);
  }

  void _alertTimer(
      {required int jumpIndex,
      required int count,
      required int index,
      required AnchorListModelEntity model}) {
    bool onePageExit = count == 1;
    alertViewController(TimerCostAlertWidget(
        onCancel: () {
          if (onePageExit) {
            popUntil(AppRoutes.tab);
          } else {
            _detailEvent(jumpIndex: jumpIndex, count: count, index: index);
          }
        },
        onConfirm: () => _onConfirm(),
        leftText: onePageExit ? "${intl.cancel}" : null,
        coins: "${model.timeDeduction}"));
  }

  void _alertTicket(
      {required int jumpIndex,
      required int count,
      required int index,
      required AnchorListModelEntity model}) {
    bool onePageExit = count == 1;
    alertViewController(TicketCostAlertWidget(
        onCancel: () {
          if (onePageExit) {
            popUntil(AppRoutes.tab);
          } else {
            _detailEvent(jumpIndex: jumpIndex, count: count, index: index);
          }
        },
        onConfirm: () => _onConfirm(),
        leftTextTitle: onePageExit ? "${intl.cancel}" : null,
        coins: "${model.ticketAmount}"));
  }

  void _onConfirm() {
    popUntil(AppRoutes.audiencePage);
    _controller.pay();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<LiveRoomNewLogic>();
    Get.delete<AgoraRtcLogic>();
    EventBus.instance.removeListener(_freeTimeOut, name: freeTimeOut);
    AgoraRtc.rtc.leaveChannel();
    AgoraRtc.rtc.removeRtcListener();
    _dragDispose();
    _pageController.dispose();
  }

  void _dragDispose() {
    _drag = null;
  }

  @override
  // TODO: implement endDraw
  Widget? get endDraw => LivingRoomEndDrawNew(
          _controller.state.rooms[_controller.state.roomIndex.value].id!,
          onTap: (rooms, index) {
        _controller.changeRoom(index: index, anchorListData: rooms);
        _pageController.animateToPage(rooms.length == 1 ? index : index + 1,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        // var model = rooms[index];
        // bool hasFreeTime = model.ticketTryseeTime != null
        //     && model.ticketTryseeTime! > 0;
        // void detailEvent(){
        //   popViewController();
        // }
        //
        // void confirmEvent(){
        //   _controller.changeRoom(index: index, data: rooms);
        //   _pageController.animateToPage(rooms.length == 1 ? index : index + 1,
        //       duration: Duration(milliseconds: 300),
        //       curve: Curves.easeIn);
        // }
        //
        // if (LiveRoomType.timer.rawValue == model.defaultroom && !hasFreeTime) {
        //   alertViewController(TimerCostAlertWidget(
        //       onCancel: ()=> detailEvent(),
        //       onConfirm: (){
        //         popUntil(AppRoutes.audiencePage);
        //         confirmEvent();
        //       },
        //       leftText: intl.cancel,
        //       coins: "${model.timeDeduction}"));
        // }else if (LiveRoomType.ticket.rawValue == model.defaultroom && !hasFreeTime){
        //   alertViewController(TicketCostAlertWidget(
        //       onCancel: ()=> detailEvent(),
        //       onConfirm: (){
        //         popUntil(AppRoutes.audiencePage);
        //         confirmEvent();
        //       },
        //       leftTextTitle: intl.cancel,
        //       coins: "${model.ticketAmount}"));
        // }else {
        //   confirmEvent();
        // }
      });

  @override
  // TODO: implement drawerScrimColor
  Color? get drawerScrimColor => Colors.transparent;

  _JumpModel _calculate({required int index, required int count}) {
    int jumpIndex;
    bool needChangePage;
    if (index == 0) {
      //当前选中的是第一个位置，自动选中倒数第二个位置
      jumpIndex = count - 2;
      needChangePage = true;
      index = jumpIndex - 1;
    } else if (index == count - 1) {
      //当前选中的是倒数第一个位置，自动选中第一个索引
      jumpIndex = 1;
      needChangePage = true;
      index = 0;
    } else {
      jumpIndex = index;
      index = index - 1;
      if (index < 0) index = 0;
      needChangePage = false;
    }
    return _JumpModel(
        index: index, jumpIndex: jumpIndex, needChangePage: needChangePage);
  }
}

class _JumpModel {
  _JumpModel(
      {required this.index,
      required this.jumpIndex,
      required this.needChangePage});

  int index;
  int jumpIndex;
  bool needChangePage;
}
