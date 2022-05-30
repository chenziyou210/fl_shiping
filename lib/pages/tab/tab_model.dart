/*
 *  Copyright (C), 2015-2021
 *  FileName: tab_handler
 *  Author: Tonight丶相拥
 *  Date: 2021/3/12
 *  Description: 
 **/


import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/manager/app_manager.dart';

class TabModel extends AppModel {
  final TabModelNotifier model = TabModelNotifier();

  void getSystemParam(){
    var setting = AppManager.getInstance<GlobalSettingModel>();
    setting.getPackageVersion();
    setting.getSystemParam();
  }
}

class TabModelNotifier extends CommonNotifierModel {
  /// 当前位置
  int _index = 0;
  int get index => _index;

  /// 更改展示页面
  void updateIndex(int index) {
    if (index == _index)
      return;
    _index = index;
    updateState();
  }
}