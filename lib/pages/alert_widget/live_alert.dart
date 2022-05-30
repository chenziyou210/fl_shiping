/*
 *  Copyright (C), 2015-2021
 *  FileName: live_alert
 *  Author: Tonight丶相拥
 *  Date: 2021/7/21
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/sample_user_info_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live_room/view/grade_image.dart';
import 'package:httpplugin/http_result_container/http_result_container.dart';


// const String _url = "https://img2.baidu.com/it/u=1077360284,2857506492&fm=26&fmt=auto&gp=0.jpg";
class LiveAlertWidget extends StatefulWidget {
  LiveAlertWidget(this.entity, this.id, {
    required this.anchorId,
    required this.isLiveOwner,
    required this.mute,
    this.onMute,
    required this.userId,
    this.hideAttentionButton: false,
    this.showCallButton: false
  });
  final SampleUserInfoEntity entity;
  final String id;
  final String userId;
  final bool isLiveOwner;
  final String anchorId;
  final bool mute;
  final void Function(int time)? onMute;
  final bool hideAttentionButton;
  final bool showCallButton;
  @override
  createState()=> _LiveAlertWidgetState(entity, mute);
}

class _LiveAlertWidgetState extends State<LiveAlertWidget> with Toast{
  _LiveAlertWidgetState(this.entity, this.mute);
  final SampleUserInfoEntity entity;
  late bool _attention;
  bool mute;
  int? time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _attention = entity.isAttrntion ?? false;
  }

  void _toggleAttention() async{
    show();
    Future<HttpResultContainer> future;
    if (_attention){
      future = HttpChannel.channel.favoriteCancel(widget.userId);
    }else {
      future = HttpChannel.channel.favoriteInsert(widget.userId);
    }
    future.then((value) => value.finalize(
      wrapper: WrapperModel(),
      failure: (e) => showToast(e),
      success: (data){
        dismiss();
        _attention = !_attention;
        if (_attention) {
          widget.entity.fansnum = (widget.entity.fansnum ?? 0) + 1;
        }else {
          widget.entity.fansnum = (widget.entity.fansnum ?? 0) - 1;
          if ((widget.entity.fansnum ?? 0) < 0) {
            widget.entity.fansnum = 0;
          }
        }
        setState(() {});
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    var intl = AppInternational.of(context);
    // TODO: implement build
    return ConsultingWarning(
        top: 37.5,
        contentPadding: EdgeInsets.zero,
        alignment: Alignment.topCenter,
        titleWidget: Positioned(
            left: (345 - 75) / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75 / 2),
              child: ExtendedImage.network(entity.header ?? "", width: 75,
                  enableLoadState: false,
                  height: 75, fit: BoxFit.cover),
            )),
        contentHeight: 299 + 37.5,
        contentWidth: 345,
        titleStrTopMargin: 4,
        radius: 10,
        contentWidget: Container(
            child: Column(
                children: [
                  Row(
                      children: [
                        SizedBox(width: 15),
                        Image.asset(AppImages.information),
                        Spacer(),
                        GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop(_attention);
                            },
                            child: Image.asset(AppImages.closeAlert)
                        ),
                        SizedBox(width: 15),
                      ]
                  ),
                  SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 46),
                        Text("${entity.username}", style: AppStyles.f22w500c38_38_40),
                        SizedBox(width: 10),
                        GradeImageWidget(entity.rank!)
                        // LevelWidget(AppImages.vipBackground, widget.entity.rank ?? 0),
                        // if (widget.isLiveOwner && !mute)
                        //   DropdownButton(
                        //     items: [
                        //       DropdownMenuItem(child: Text("${intl.mute}"), value: -1),
                        //       DropdownMenuItem(child: Text("${intl.oneMinute}"), value: 0),
                        //       DropdownMenuItem(child: Text("${intl.oneHour}"), value: 1),
                        //       DropdownMenuItem(child: Text("${intl.oneDay}"), value: 2),
                        //       DropdownMenuItem(child: Text("${intl.forever}"), value: 3)
                        //     ], value: -1,
                        //     onChanged: (index) {
                        //       if (index == -1)
                        //         return;
                        //       time = 1;
                        //       // if (index == 0) {
                        //       //   time = 1;
                        //       // }else
                        //       if (index == 1) {
                        //         time = 60;
                        //       }else if (index == 2){
                        //         time = 60 * 24;
                        //       }else if (index == 3) {
                        //         time = double.infinity.toInt();
                        //       }
                        //       show();
                        //       HttpChannel.channel.banSpeak(widget.anchorId, widget.id, time!)
                        //         .then((value)=> value.finalize(
                        //           wrapper: WrapperModel(),
                        //           failure: (e) => showToast(e),
                        //           success: (_) {
                        //             dismiss();
                        //             mute = true;
                        //             setState(() {});
                        //             widget.onMute?.call(time!);
                        //           }
                        //       ));
                        //     },
                        //     style: AppStyles.f14w400c0_0_0,
                        //     underline: SizedBox())
                        //     .padding(padding: EdgeInsets.only(left: 8))
                        // else if (widget.isLiveOwner && mute)
                        //   CustomText("${intl.muting}", style: AppStyles.f14w400c105_199_49.copyWith(
                        //     color: AppColors.c231_231_231
                        //   )).padding(padding: EdgeInsets.only(left: 8))
                      ]
                  ),
                  SizedBox(height: 4),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${intl.id}：${entity.memberid}", style: AppStyles.f14w400c0_0_0
                            .withOpacity(0.6)),
                        SizedBox(width: 19),
                        Image.asset(AppImages.location),
                        SizedBox(width: 4),
                        Text("${entity.city}", style: AppStyles.f14w400c0_0_0.withOpacity(0.6))
                      ]
                  ),
                  SizedBox(height: 16),
                  Text("${entity.signature}", style: AppStyles.f14w400c0_0_0.withOpacity(0.6))
                    .padding(padding: EdgeInsets.symmetric(
                    horizontal: 8
                  )),
                  SizedBox(height: 34),
                  Row(
                      children: [
                        Expanded(
                            child: Column(
                                children: [
                                  Text("${entity.attentionnum}", style: AppStyles.f18w400c0_0_0),
                                  SizedBox(height: 3),
                                  Text(intl.following, style: AppStyles.f12w400c0_0_0.withOpacity(0.6))
                                ]
                            )
                        ),
                        Expanded(
                            child: Column(
                                children: [
                                  Text("${entity.fansnum}", style: AppStyles.f18w400c0_0_0),
                                  SizedBox(height: 3),
                                  Text(intl.followers, style: AppStyles.f12w400c0_0_0.withOpacity(0.6))
                                ]
                            )
                        ),
                        if (!widget.hideAttentionButton)
                        Expanded(
                            child: Column(
                                children: [
                                  Text("${entity.sendgiftnum}", style: AppStyles.f18w400c0_0_0),//${entity.hitting}
                                  SizedBox(height: 3),
                                  Text(intl.hitting, style: AppStyles.f12w400c0_0_0.withOpacity(0.6))
                                ]
                            )
                        )
                      ]
                  )
                ]
            )
        ),
        bottomWidget: Column(
            children: [
              CustomDivider(
                  color: AppColors.c0_0_0.withOpacity(0.1),
                  height: 1
              ),
              SizedBox(
                height: 64,
                child: Row(
                    children: [
                      Expanded(child: InkWell(
                        onTap: (){
                          Navigator.of(context).pushNamed(AppRoutes.userById, arguments: {
                            "id": widget.id
                          }).then((value) {
                            // if (value != null && value is bool) {
                            //   entity.isAttrntion = value;
                            //   _attention = value;
                            //   setState((){});
                            // }
                          });
                        }, child: ConstrainsExpandWidget(
                              child: Center(
                                  child: Text(intl.home, style: AppStyles.f16w400c0_0_0.withOpacity(0.8))
                              )
                          )
                      )),
                      Container(
                          height: 18,
                          width: 1,
                          color: AppColors.c0_0_0.withOpacity(0.1)
                      ),
                      if (widget.showCallButton)
                      Expanded(child: InkWell(
                          onTap: (){
                            // print(222222);
                            Navigator.of(context).pop({
                              "action": 1
                            });

                            //this.name = arguments["name"],
                            //         this.id = arguments["id"],
                            //         this.isFollowed = arguments["isFollowed"] ?? false
                            // Navigator.of(context).popAndPushNamed(AppRoutes.conversation,
                            //   arguments: {
                            //     "name": entity.username,
                            //     "id": widget.id,
                            //     "isFollowed": entity.isAttrntion
                            //   });
                          },
                          child: ConstrainsExpandWidget(
                              child: Center(
                                  child: Text("@TA", style: AppStyles.f16w400c0_0_0.withOpacity(0.8))
                              )
                          )
                      )),
                      if (!widget.hideAttentionButton)
                      Container(
                          height: 18,
                          width: 1,
                          color: AppColors.c0_0_0.withOpacity(0.1)
                      ),
                      if (!widget.hideAttentionButton)
                      Expanded(child: InkWell(
                          onTap: (){
                            _toggleAttention();
                          },
                          child: ConstrainsExpandWidget(
                              child: Center(
                                  child: !_attention ? Text("${"+" + intl.attention}",
                                      style: AppStyles.f16w400c165_59_227) :
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AppImages.followedImage),
                                        SizedBox(width: 4),
                                        Text(intl.followed, style: AppStyles.f16w400c0_0_0.withOpacity(0.8))
                                      ]
                                  )
                              )
                          )
                      ))
                    ]
                ),
              )
            ]
        )
    );
  }
}

// class AnchorModel {
//   AnchorModel({this.signature, this.level, this.name,
//     this.account, this.following, this.isFollowed = false,
//     this.url, this.follower, this.hitting,
//     this.location});
//   final String? url;
//   final String? name;
//   final int? level;
//   final String? account;
//   final String? location;
//   final String? signature;
//   final int? following;
//   final int? follower;
//   final int? hitting;
//   final bool isFollowed;
// }