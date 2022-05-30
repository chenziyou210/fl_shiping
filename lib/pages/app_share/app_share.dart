/*
 *  Copyright (C), 2015-2022
 *  FileName: app_share
 *  Author: Tonight丶相拥
 *  Date: 2022/4/20
 *  Description: 
 **/

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


class AppSharePage extends StatelessWidget with Toast {
  AppSharePage({dynamic arguments}): this.code = arguments["code"];
  final GlobalKey _boundaryKey = GlobalKey();
  final String code;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var intl = AppInternational.of(context);
    String link = "${Provider.of<SettingViewModel>(context).shareApp?.downloadUrl}?code=$code";
    return Scaffold(
      appBar: DefaultAppBar(
        title: CustomText("${intl.shareLink}",
          fontSize: 16,
          fontWeight: w_500,
          color: Color.fromARGB(255, 34, 40, 49)
        )
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          RepaintBoundary(
            key: _boundaryKey,
            child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(AppImages.shareBackground).sizedBox(),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppImages.logInLogo, width: 40, height: 40),
                        SizedBox(width: 4),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(intl.packageName,
                                  fontSize: 14,
                                  fontWeight: w_500,
                                  color: Colors.white
                              ),
                              SizedBox(height: 4),
                              CustomText(intl.willMeetYouSoon,
                                  fontSize: 10,
                                  fontWeight: w_400,
                                  color: Colors.white
                              )
                            ]
                        )
                      ]
                  ).position(right: 8, top: 12),
                  Stack(
                      children: [
                        Image.asset(AppImages.qrBackground),
                        QrImage(data: link).positionFill()
                      ]
                  ).container(width: 162, height: 162).position(bottom: 100)
                ]
            ),
          ),
          SizedBox(height: 32),
          CustomText(intl.scanCodeDownload,
            fontSize: 12,
            fontWeight: w_500,
            color: Color.fromARGB(255, 123, 127, 139)
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomGradientBorderContainer(gradient: LinearGradient(
                colors: AppColors.buttonGradientColors
              ),
                child: CustomText(intl.copyLink,
                  fontSize: 16,
                  fontWeight: w_400,
                  color: Color.fromARGB(255, 236, 124, 233),
                ).padding(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8)),
                radius: 20
              ).cupertinoButton(onTap: (){
                Clipboard.setData(ClipboardData(text: link));
                showToast(intl.copySuccess);
              }),
              SizedBox(width: 32),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.buttonGradientColors
                  ),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: CustomText(intl.saveToLocal,
                  fontSize: 16,
                  fontWeight: w_400,
                  color: Colors.white,
                ),
              ).cupertinoButton(onTap: (){
                toPng();
              })
            ]
          ),
          SizedBox(height: 16)
        ]
      ).sizedBox(width: double.infinity)
    );
  }

  void toPng() async {
    show();
    var intl = AppInternational.current;
    try {
      RenderRepaintBoundary boundary =
      _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null)
        return null;
      Uint8List pngBytes = byteData.buffer.asUint8List();
      PermissionStatus result;
      if (Platform.isIOS) {
        result = await Permission.photos.request();
      }else {
        result = await Permission.storage.request();
      }
      if (result.isDenied) {
        showToast(intl.pleaseAuthorizeSaveToPhoto);
        return null;
      }
      await ImageGallerySaver.saveImage(pngBytes, quality: 100);
      showToast(intl.save + intl.success);
    } catch (e) {
      showToast(e.toString());
    }
  }
}