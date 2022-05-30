/*
 *  Copyright (C), 2015-2021
 *  FileName: live_exit_alert
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
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/manager/app_manager.dart';

// const String _url = "https://img2.baidu.com/it/u=1077360284,2857506492&fm=26&fmt=auto&gp=0.jpg";
class LiveExitAlert extends AlertDialog {
  LiveExitAlert({this.onPop, required this.url,
    required this.userId, required this.anchorId});
  final VoidCallback? onPop;
  final String url;
  final String anchorId;
  final String userId;

  @override
  // TODO: implement contentPadding
  EdgeInsetsGeometry get contentPadding => EdgeInsets.zero;

  @override
  // TODO: implement content
  Widget? get content => Builder(builder: (context) {
    var intl = AppInternational.of(context);
    return Stack(
        children: [
          CircleAvatar( radius: 64,
            backgroundImage: NetworkImage(url),
            child: Container(
              alignment: Alignment(0, .5),
            ),),
          Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(padding: EdgeInsets.only(
                        right: 17, top: 17
                      ), child: InkWell(
                          onTap: onPop,
                          child: Image.asset(AppImages.closeAlert)
                      ))
                    ]
                ),
                ClipRRect(
                  child: ExtendedImage.network(url, width: 64, height: 64,
                      fit: BoxFit.cover, enableLoadState: false),
                  borderRadius: BorderRadius.circular(64 / 2),
                ),
                SizedBox(height: 13),
                Text(intl.followTheAnchor, style: AppStyles.f16w500c38_38_40),
                SizedBox(height: 23),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop(true);
                    HttpChannel.channel.audienceExitRoom(roomId: userId,
                        follow: true).then((value) =>
                        value.finalize(
                          wrapper: WrapperModel(),
                          success: (_) {
                            AppManager.getInstance<AppUser>().addAttention();
                          }
                        )
                    );
                  },
                  child: Container(
                    width: 180, height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: AppColors.buttonGradientColors
                      )
                    ),
                    child: Text(intl.followAndExit, style: AppStyles.f16w400c255_255_255),
                  ),
                  // child: Stack(
                  //   alignment: Alignment.center,
                  //   children: [
                  //     Image.asset(AppImages.confirmButton, width: 180, height: 40, fit: BoxFit.fill),
                  //   ]
                  // )
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black38,
                        width: 0.5
                      )
                    ),
                    alignment: Alignment.center,
                    child: CustomText(intl.dropOut, style: AppStyles.f16w400c165_59_227.copyWith(
                      color: Colors.black38
                    ))
                  )
                )
              ]
          )
        ]
    );
  });
}