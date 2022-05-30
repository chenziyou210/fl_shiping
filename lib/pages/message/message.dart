/*
 *  Copyright (C), 2015-2021
 *  FileName: message
 *  Author: Tonight丶相拥
 *  Date: 2021/7/16
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';

class Message extends StatefulWidget {
  @override
  createState() => _MessageState();
}

class _MessageState extends AppStateBase<Message> {
  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.message, style: AppStyles.f17w400c0_0_0)
  );
}

