/*
 *  Copyright (C), 2015-2021
 *  FileName: live_room_preview_new
 *  Author: Tonight丶相拥
 *  Date: 2021/12/9
 *  Description: 
 **/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/agora_rtc/agora_rtc.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live/live_new_logic.dart';
import 'package:hjnzb/pages/live_room_preview/live_room_type.dart';
import 'package:httpplugin/http_result_container/http_result_container.dart';
import 'live_room_preview_new_logic.dart';
import 'beauty_view.dart';
import '../live/label_view/label_view.dart';


class LiveRoomPreviewNewPage extends StatefulWidget {
  @override
  createState() => _LiveRoomPreviewNewPageState();
}

class _LiveRoomPreviewNewPageState extends AppStateBase<LiveRoomPreviewNewPage> with Toast {

  /// 数据控制器
  final LiveRoomPreviewNewLogic _controller = LiveRoomPreviewNewLogic();

  /// 加载
  late Future _future;

  /// 需要释放
  bool _needRelease = true;

  /// 上传
  final UploadModel _uploadController = UploadModel();

  /// 直播标题
  final TextEditingController _livingTitleController = TextEditingController();

  /// 砖石
  final TextEditingController _diamondController = TextEditingController();

  /// vip等级
  final TextEditingController _vipController = TextEditingController();

  /// 计时收费
  final TextEditingController _timeController = TextEditingController();

  int _percent = 0;

  /// 封面地址
  String _url ="https://img01.sc115.com/uploads/sc/jpgs/06/xpic1024_sc115.com.jpg";

  final TextStyle _hintStyle = TextStyle(
      color: Color.fromARGB(255, 196, 196, 196),
      fontSize: 17.pt,
      fontWeight: w_400
  );

  final TextStyle _style = TextStyle(
      color: Colors.black,
      fontSize: 17.pt,
      fontWeight: w_400
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controller);
    var m = BeautyModel.initialize()
      ..setEffect();
    Get.put(m);
    _future = AgoraRtc.rtc.preview();
    // _destroyRoom();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<LiveRoomPreviewNewLogic>();
    if (_needRelease) {
      AgoraRtc.rtc.leaveChannel();
      Get.delete<BeautyModel>();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoadingWidget(builder: (_, __) {
      return scaffold;
    }, future: _future);
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    automaticallyImplyLeading: false,
    leading: SizedBox(),
    backgroundColor: Colors.transparent,
    actions: [
      IconButton(
        iconSize: 36.pt,
        onPressed: (){
          AgoraRtc.rtc.switchCamera();
        },
        icon: Image.asset(AppImages.switchCamera, fit: BoxFit.fill))
    ]
  );
  
  @override
  // TODO: implement body
  Widget get body => Stack(
    children: [
      Container(),
      Positioned.fill(child: LocalView()),
      Container(
        width: 343.pt,
        margin: EdgeInsets.only(left: 16.pt,
          top: 32.pt),
        padding: EdgeInsets.symmetric(
          horizontal: 14, vertical: 20
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                UploadWidget(
                  width: 60.pt,
                  height: 60.pt,
                  controller: _uploadController,
                  color: Colors.white,
                  onPercent: (percent) {
                    this._percent = percent;
                  },
                  uploadSuccess: (url) {
                    this._url = url;
                    /*
                    * if (_uploadController.isUploading) {
                              showToast("cover image is uploading");
                              return;
                            }*/
                  }
                ),
                SizedBox(width: 8),
                CustomTextField(
                  hintText: "${intl.pleaseEnterLivingTitle}",
                  hintTextStyle: _hintStyle,
                  textAlignVertical: TextAlignVertical.center,
                  style: _style,
                  controller: _livingTitleController
                ).container(
                  width: 60.pt,
                  height: 60.pt,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                  )
                ).expanded()
              ]
            ),
            SizedBox(height: 8.pt),
            Row(
              children: [
                Wrap(
                  runSpacing: 8.pt,
                  spacing: 16.pt,
                  children: _controller.state.types.map((e) {
                    return Obx((){
                      bool isAtIndex = e == _controller.state.type.value;
                      return Container(
                        height: 27.pt,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8
                        ),
                        child: [CustomText("${e.description}",
                          fontSize: 12.pt,
                          fontWeight: w_400,
                          color: Colors.white
                        )].column(
                          mainAxisAlignment: MainAxisAlignment.center
                        ),
                        decoration: BoxDecoration(
                          border: isAtIndex ? null : Border.all(
                            color: Colors.white
                          ),
                          gradient: isAtIndex ? LinearGradient(
                            colors: AppColors.buttonGradientColors)
                              : null,
                          borderRadius: BorderRadius.circular(13.5.pt)
                        )
                      ).gestureDetector(
                        onTap: (){
                          _controller.changeLiveRoomType(e);
                        }
                      );
                    });
                  }).toList()
                ).expanded()
              ]
            ),
            SizedBox(height: 16.pt),
            Obx((){
              Widget createTextField(String hintText, TextEditingController controller){
                return CustomTextField(
                    controller: controller,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatter: [
                      OnlyInputInt()
                    ],
                    hintText: "$hintText",
                    hintTextStyle: _hintStyle,
                    style: _style
                );
              }
              var type = _controller.state.type.value;
              var vipWidget = createTextField(intl.pleaseSettingWatchVipGrade,
                  _vipController);

              var diamondWidget = createTextField(intl.pleaseEnterExpenseDiamondNumber,
                  _diamondController);

              var timerWidget = createTextField(intl.pleaseEnterTimerMinute,
                  _timeController);

              Widget container(Widget child){
                return Container(
                    width: 315.pt,
                    height: 44.pt,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                  child: child,
                );
              }

              if (type == LiveRoomType.game || type == LiveRoomType.common) {
                return container(vipWidget);
              }else if (type == LiveRoomType.timer || type == LiveRoomType.ticket) {
                return Column(
                  children: [
                    container(diamondWidget),
                    SizedBox(height: 16.pt),
                    container(timerWidget)
                  ]
                );
              }else {
                return container(diamondWidget);
              }
            }),
            SizedBox(height: 16),
            CustomText(intl.labelCategory, fontSize: 12.pt,
              fontWeight: w_400,
              color: Colors.white),
            SizedBox(height: 12),
            LabelView(onTap: (i){
              _controller.labelChange(i);
            }, selectJudge: (i) => _controller.state.indexes.contains(i))
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        )
      ).safeArea(
        left: false, right: false, bottom: false
      ),
      Positioned(
        child: Row(
          children: [
            CupertinoButton(
              onPressed: (){
                customShowModalBottomSheet(context: context,
                  fixedOffsetHeight: this.height * 0.5,
                  isScrollControlled: false,
                  barrierColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return BeautyView();
                  });
              },
              child: Row(
                children: [
                  Image.asset(AppImages.beauty_new),
                  SizedBox(width: 4),
                  CustomText("${intl.beauty}",
                    fontWeight: w_500,
                    fontSize: 16.pt,//rgba(228, 31, 39, 1)
                    color: Color.fromARGB(255, 228, 31, 39)
                  )
                ]
              ).container(
                height: 60.pt,
                padding: EdgeInsets.symmetric(
                  horizontal: 16
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.pt)
                )
              ),
            ),
            CupertinoButton(
              child: CustomText("${intl.startLive}",
                fontSize: 16.pt,
                fontWeight: w_500,
                color: Colors.white
              ).container(
                alignment: Alignment.center,
                width: 205.pt, height: 60.pt,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.buttonGradientColors),
                  borderRadius: BorderRadius.circular(30.pt)
                )
              ),
              padding: EdgeInsets.zero,
              onPressed: () async{
                var roomTitle = _livingTitleController.text;
                var diamond = _diamondController.text;
                var time = _timeController.text;
                var vip = _vipController.text;
                if (roomTitle.isEmpty) {
                  showToast("${intl.pleaseEnterLivingTitle}");
                  return;
                }

                if (_uploadController.isUploading && _percent != 100) {
                  showToast("${intl.liveCoverIsUploading} -- $_percent%");
                  return;
                }
                // if (_url == null || _url!.isEmpty) {
                //   showToast("${intl.pleaseUploadLiveCover}");
                //   return;
                // }
                // todo: 开始直播
                // await _destroyRoom();
                Future<HttpResultContainer> future;
                var type = _controller.state.type.value;
                var labels = Get.find<LiveNewLogic>().state.labels;
                var valueLst = _controller.state.indexes.map((element) =>
                  labels[element].id).toList();
                String anchorType = valueLst.join("-");
                if (type == LiveRoomType.game || type == LiveRoomType.common) {
                  int? v = int.tryParse(vip);
                  if (vip.isEmpty || v == null) {
                    showToast("${intl.pleaseSettingWatchVipGrade}");
                    return;
                  }
                  if (type == LiveRoomType.game) {
                    future = HttpChannel.channel.createGameRoom(
                      roomTitle: roomTitle,
                      cover: _url,
                      anchorType: anchorType,
                      level: v);
                  }else {
                    future = HttpChannel.channel.createCommonRoom(
                      roomTitle: roomTitle,
                      cover: _url,
                      anchorType: anchorType,
                      level: v);
                  }
                }else {
                  double? v = double.tryParse(diamond);
                  if (v == null) {
                    showToast("${intl.pleaseEnterExpenseDiamondNumber}");
                    return;
                  }
                  if (type == LiveRoomType.ticket) {
                    future = HttpChannel.channel.createTickerAmountRoom(
                        roomTitle: roomTitle,
                        cover: _url,
                        anchorType: anchorType,
                        ticketAmount: v,
                        minute: time
                    );
                  }else {
                    future = HttpChannel.channel.createTimeDeductionRoom(
                        roomTitle: roomTitle,
                        cover: _url,
                        anchorType: anchorType,
                        timeDeduction: v,
                        minute: time);
                  }
                }
                show();
                future.then((value) => value.finalize(
                  wrapper: WrapperModel(),
                  failure: (e)=> showToast(e),
                  success: (data) {
                    dismiss();
                    var channelName = data["channelName"];
                    var chatRoomId = data["chatRoomId"];
                    var channelToken = data["channelToken"];
                    var channelUid = data["channelUid"];
                    var roomId = data["roomId"];
                    _needRelease = false;
                    Navigator.of(context).popAndPushNamed(AppRoutes.anchorPage, arguments: {
                      "channelName": channelName,
                      "channelToken": channelToken,
                      "chatRoomId": chatRoomId,
                      "channelUid": channelUid,
                      "roomId": roomId.toString()
                    });
                  }
                ));
            })
          ]
        ),
        left: 16, bottom: 32.pt
      )
    ]
  );

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => Colors.black12;

  // Future<void> _destroyRoom(String roomId) async{
  //   await HttpChannel.channel.destroyRoom(
  //       roomId: roomId);
  //   return;
  // }

  @override
  // TODO: implement resizeToAvoidBottomInset
  bool? get resizeToAvoidBottomInset => false;
}