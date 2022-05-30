/*
 *  Copyright (C), 2015-2021
 *  FileName: game_item
 *  Author: Tonight丶相拥
 *  Date: 2021/11/27
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/pages/live_room/view/game_view/game_image.dart';

Widget getItem(String gameName, String value, {Size? size, BoxFit? fit}) {
  if (value.isEmpty)
    return SizedBox(width: 8);
  var key = gameName + "_" + value;

  String? correspondKey = correspond[key];
  if (correspondKey != null){
    key = correspondKey;
  }

  String? result = commonImage[key];
  if (result == null) {
    if (AppInternational.current is $zh_CN){
      result = image$zh[key];
    }else {
      result = image$us[key];
    }
  }
  if (result == null) {
    return SizedBox.shrink();
  }

  return Image.asset(result, width: size?.width,
    height: size?.height, fit: fit);
}

/// AppImages.imageBase + gameName
//     + "_" + value + ".png"