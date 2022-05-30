/*
 *  Copyright (C), 2015-2021
 *  FileName: page_generate
 *  Author: Tonight丶相拥
 *  Date: 2021/7/13
 *  Description: 
 **/


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/page_config/page_config.dart';
// import 'package:get/get.dart';

class PageGenerate {
  static Route<dynamic>? generate(RouteSettings settings) {
    String? name = settings.name;
    dynamic arguments = settings.arguments;
    var generate = pageConfig[name];
    Widget widget;
    if (name != null && generate != null) {
      widget = generate.getInstance(arguments);
    }else {
      return null;
    }
    // return GetPageRoute();
    return CupertinoPageRoute(builder: (_) {
      return widget;
    }, settings: RouteSettings(
      name: name,
      arguments: arguments
    ));
  }
}