/*
 *  Copyright (C), 2015-2021
 *  FileName: live_new_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/7
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/generated/app_activity_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/pages/login/user_info_operation.dart';

class LiveNewLogic extends GetxController with WidgetsBindingObserver {

  LiveNewLogic(){
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      UserInfoOperation().imLogIn();
    }
  }


  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete {
    WidgetsBinding.instance?.removeObserver(this);
    return super.onDelete;
  }

  final _LiveNewState state = _LiveNewState();

  Future load(){
    return Future.wait([appActivityLoad(), HttpChannel.channel.gameConfig()..then((value)=>
        value.finalize(
            wrapper: WrapperModel(),
            success: (value) {
              AppManager.getInstance<Game>().initializeGame(value);
            }
        )),
      labelLoad()
      ]);
  }

  Future appActivityLoad(){
    return HttpChannel.channel.appActivity()..then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data ?? [];
          List<AppActivityEntity> banner = lst.map((e) => AppActivityEntity.fromJson(e)).toList();
          state._setBanner(banner);
        }
    ));
  }
  
  Future labelLoad(){
    return HttpChannel.channel.systemDictionary()..then((value) =>
        value.finalize(
            wrapper: WrapperModel(),
            success: (data) {
              List lst = data ?? [];
              lst = lst.where((e) => e["dicType"] == "ANCHOR_LABEL_LIST").toList();
              state._setLabels(lst.map((e) => _LabelEntity(
                id: e["dicValue"].toString(),
                title: e["dicCnValue"]
              )).toList());
            }
        ));
  }

  void setLabelIndex(int value){
    state._setLabelIndex(value);
  }
}

class _LiveNewState {
  RxList<AppActivityEntity> _banner = RxList();
  RxList<AppActivityEntity> get banner => _banner;


  RxList<_LabelEntity> _label = RxList();
  RxList<_LabelEntity> get labels => _label;

  RxInt _labelIndex = (-1).obs;
  RxInt get labelIndex => _labelIndex;

  void _setLabelIndex(int value){
    _labelIndex.value = value;
  }

  void _setBanner(List<AppActivityEntity> banners){
    this._banner.value = banners;
  }

  void _setLabels(List<_LabelEntity> value){
    _label.value = value;
  }
}

class _LabelEntity {
  _LabelEntity({required this.title, required this.id});
  final String title;
  final String id;
}
