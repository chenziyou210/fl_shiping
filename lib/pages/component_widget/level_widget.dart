/*
 *  Copyright (C), 2015-2021
 *  FileName: level_widget
 *  Author: Tonight丶相拥
 *  Date: 2021/7/19
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_styles.dart';

class LevelWidget extends StatelessWidget {
  LevelWidget(this.image, this.level);
  final String image;
  final int level;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(image),
          Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("$level", style: AppStyles.f10w400c255_255_255)
          )
        ]
    );
  }
}