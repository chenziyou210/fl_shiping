/*
 *  Copyright (C), 2015-2021
 *  FileName: advertising_model
 *  Author: Tonight丶相拥
 *  Date: 2021/10/18
 *  Description: 
 **/

import 'dart:async';
import 'package:get/get.dart';
import 'package:hjnzb/base/app_base.dart';

class AdvertisingModel extends AppModel {
  AdvertisingModel(this._timeUp);
  final void Function() _timeUp;
  Timer? _timer;
  final AdvertisingViewModel viewModel = AdvertisingViewModel();
  @override
  Future loadData() {
    // TODO: implement loadData
    Get.put(AdvertisingViewModel());
    _timerInitialize();
    return super.loadData();
  }

  void dispose(){
    timerCancel();
    _timer = null;
    Get.delete<AdvertisingViewModel>();
  }

  /// timer 取消
  void timerCancel(){
    _timer?.cancel();
  }

  /// timer 初始化
  void _timerInitialize() {
    _timer = Timer.periodic(Duration(seconds: 1), (_){
      if (viewModel._count.value <= 0) {
        _timeUp();
        timerCancel();
        return;
      }
      viewModel._substract();
    });
  }
}

class AdvertisingViewModel extends GetxController {
  RxInt _count = 9.obs;
  RxInt get count => _count;
  RxBool canSkip = false.obs;

  void _substract(){
    _count.value -= 1;
  }
}