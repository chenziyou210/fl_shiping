/*
 *  Copyright (C), 2015-2021
 *  FileName: game_question_alter
 *  Author: Tonight丶相拥
 *  Date: 2021/12/16
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';

class GameQuestionAlter extends AlertDialog {
  GameQuestionAlter(this.text, {this.onClose});
  final String text;
  final VoidCallback? onClose;

  @override
  Widget? get content => Stack(children: [
        SingleChildScrollView(child: Html(data: text))
            .container(padding: EdgeInsets.only(top: 24), height: 300.pt),
        Positioned(
            child: Image.asset(AppImages.closeAlert)
                .cupertinoButton(onTap: onClose),
            right: 0,
            top: 8)
      ]);

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.symmetric(horizontal: 8);
}
